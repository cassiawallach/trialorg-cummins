public without sharing class dbu_CalculateDates {
    public static dbu_CartItemWrapper estimatedPickUpDateCalculate(dbu_CartItemWrapper CARTITEM_WRAPPER_DETAILS , 
                                                                   list<Dbu_InventoryWrapper> INVENTORY_RESPPONSE, 
                                                                   ccrz__E_Cart__c CART_DETAILS){
                                                                       
                                                                       
                                                                       
                                                                       //string JSONISED_RESPONSE = '[{"Inventory":{"items":{"item":[{"availableQuantity": "0", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "IRD"},{"availableQuantity": "270", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "DRD"},{"availableQuantity": "130", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "PRD"},{"availableQuantity": "142", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "ARD"},{"availableQuantity": "244", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "HRD"},{"availableQuantity": "15", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "K6"},{"availableQuantity": "356", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "X5"},{"availableQuantity": "34", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "N8"},{"availableQuantity": "0", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "A1"},{"availableQuantity": "121", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "E4"},{"availableQuantity": "100", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "N9"},{"availableQuantity": "34", "availableQuantityDownOrder": "0", "partNumber": "498828000", "warehouse": "Y9"}]}}}]';
                                                                       //system.debug('JSONISED_RESPONSE > ' + JSONISED_RESPONSE);
                                                                       
                                                                       list<Dbu_InventoryWrapper> DEJSONIESD_RESPONSE = new list<Dbu_InventoryWrapper>();	                                                        
                                                                       //DEJSONIESD_RESPONSE = Dbu_InventoryWrapper.parse(JSONISED_RESPONSE);
                                                                       DEJSONIESD_RESPONSE = INVENTORY_RESPPONSE;                                                        
                                                                       system.debug('DEJSONIESD_RESPONSE > ' + DEJSONIESD_RESPONSE);                                                    
                                                                       system.debug('CART_DETAILS > ' + CART_DETAILS);
                                                                       
                                                                       //just for example                                                        
                                                                       string STORE_CODE;
                                                                       string ORDER_FROM;	
                                                                       string BRANCH_CITY;
                                                                       string BRANCH_STATE;
                                                                       string BRANCH_COUNTRY;
                                                                           
                                                                       Decimal USER_INPUT_QUANTITY = 0;
                                                                       
                                                                       if(CART_DETAILS != null){
                                                                           
                                                                           //GET STORE CODE
                                                                           if(CART_DETAILS.dbu_StoreCode__c != null){
                                                                               STORE_CODE = CART_DETAILS.dbu_StoreCode__c;
                                                                           }
                                                                           
                                                                           //GET STORE COUNTRY
                                                                           if(CART_DETAILS.dbu_Cart_StoreCountry__c != null){
                                                                           	   BRANCH_COUNTRY = CART_DETAILS.dbu_Cart_StoreCountry__c;
                                                                               system.debug('BRANCH_COUNTRY > ' + BRANCH_COUNTRY);
                                                                           }
                                                                           
                                                                           if(CART_DETAILS.dbu_Pick_Up_From_Store__r != null){
                                                                               //GET ZONE -RDC, MDC, CPW
                                                                               if(CART_DETAILS.dbu_Pick_Up_From_Store__r.dbu_zone__c != null){
                                                                                   ORDER_FROM = CART_DETAILS.dbu_Pick_Up_From_Store__r.dbu_zone__c; 
                                                                               }
                                                                               if(CART_DETAILS.dbu_Pick_Up_From_Store__r.ccrz__City__c != null){
                                                                                   BRANCH_CITY = CART_DETAILS.dbu_Pick_Up_From_Store__r.ccrz__City__c;
                                                                                   system.debug('BRANCH_CITY > ' + BRANCH_CITY);
                                                                               }
                                                                               if(CART_DETAILS.dbu_Pick_Up_From_Store__r.ccrz__State__c != null){
                                                                               	   BRANCH_STATE = CART_DETAILS.dbu_Pick_Up_From_Store__r.ccrz__State__c;	 	   
                                                                                   system.debug('BRANCH_STATE > ' + BRANCH_STATE);
                                                                               }                                                                               
                                                                           }                                                            
                                                                       }                                                    
                                                                       
                                                                       //USER SUPPLIED QTY   	                                                     
                                                                       if(CARTITEM_WRAPPER_DETAILS != null){
                                                                           if(CARTITEM_WRAPPER_DETAILS.cartItem != null){
                                                                               if(CARTITEM_WRAPPER_DETAILS.cartItem.ccrz__Quantity__c != NULL){
                                                                                   USER_INPUT_QUANTITY = CARTITEM_WRAPPER_DETAILS.cartItem.ccrz__Quantity__c;
                                                                               }                                                            
                                                                           }        	
                                                                       }                                                        
                                                                       
                                                                       //STORE_CODE = 'E4';
                                                                       
                                                                       string STOCK_STATUS;
                                                                       Decimal availableQty = 0;                                                        
                                                                       
                                                                       //DETERMINE INSTOCK, OUT STOCK, PARTIAL STOCK & API GIVEN QUANTITY
                                                                       if(DEJSONIESD_RESPONSE != null && DEJSONIESD_RESPONSE.size() > 0 && DEJSONIESD_RESPONSE[0].Inventory != null){
                                                                           system.debug('BAKU > ' + DEJSONIESD_RESPONSE[0].Inventory);
                                                                           if((DEJSONIESD_RESPONSE[0].Inventory).items != null){
                                                                               system.debug('INventory map > ' + (DEJSONIESD_RESPONSE[0].Inventory).items);
                                                                               if((DEJSONIESD_RESPONSE[0].Inventory).items != null){
                                                                                   system.debug('Items map > ' + ((DEJSONIESD_RESPONSE[0].Inventory).items).item);   
                                                                                   if(((DEJSONIESD_RESPONSE[0].Inventory).items).item != null){
                                                                                       if((((DEJSONIESD_RESPONSE[0].Inventory).items).item).size() > 0){
                                                                                           list<Dbu_InventoryWrapper.Item> listofItems = new list<Dbu_InventoryWrapper.Item>();
                                                                                           listofItems = ((DEJSONIESD_RESPONSE[0].Inventory).items).item;
                                                                                           system.debug('listofItems > ' + listofItems);
                                                                                           Boolean isStoreFound = false;
                                                                                           for(Dbu_InventoryWrapper.Item eachItem : listofItems){
                                                                                               if(STORE_CODE == eachItem.warehouse){
                                                                                                   isStoreFound = true;
                                                                                                   system.debug('eachItem > ' + eachItem.availableQuantity+'\tUSER_INPUT_QUANTITY\t'+USER_INPUT_QUANTITY);
                                                                                                   
                                                                                                   if(string.isNotBlank(eachItem.availableQuantity) && Decimal.valueOf(eachItem.availableQuantity) > 0){
                                                                                                       //INSTOCK OR PARTIAL STOCK
                                                                                                       system.debug('eachItem.availableQuantity== > ' + eachItem.availableQuantity+'\tUSER_INPUT_QUANTITY\t'+USER_INPUT_QUANTITY);
                                                                                                       if(Decimal.valueOf(eachItem.availableQuantity) >= USER_INPUT_QUANTITY){
                                                                                                           STOCK_STATUS = 'In-Stock';
                                                                                                           availableQty = Decimal.valueOf(eachItem.availableQuantity);
                                                                                                           system.debug('In-Stock== > ' + availableQty);
                                                                                                       }else if(Decimal.valueOf(eachItem.availableQuantity) < USER_INPUT_QUANTITY){
                                                                                                           STOCK_STATUS = 'Partial In-Stock';
                                                                                                           availableQty = Decimal.valueOf(eachItem.availableQuantity);
                                                                                                           system.debug('Partial In-Stock== > ' + availableQty);
                                                                                                       }
                                                                                                    }else{
                                                                                                        //OUT OF STOCK
                                                                                                        STOCK_STATUS = 'Out of Stock'; 
                                                                                                        availableQty = 0;
                                                                                                        //ITERATION OF OTHER STORES                                    
                                                                                                    }
                                                                                               }                                               
                                                                                           } 
                                                                                           if(!isStoreFound){
                                                                                               //OUT OF STOCK
                                                                                               STOCK_STATUS = 'Out of Stock'; 
                                                                                               availableQty = 0;
                                                                                           }
																						}else{
																							//Added by shriram on 24th Nov 2021 to handle exception case
																							STOCK_STATUS = 'Out of Stock'; 
																							availableQty = 0;
																						}                 
                                                                                    }
                                                                               }    
                                                                           }else{
																			   //Added by shriram on 24th Nov 2021 to handle exception case
																			   STOCK_STATUS = 'Out of Stock'; 
																			   availableQty = 0;
																		   }
                                                                        }else{
                                                                                system.debug('YEREVAN');
                                                                                //Added by shriram on 19th Nov 2021 to handle exception case
                                                                                STOCK_STATUS = 'Out of Stock'; 
                                                                                availableQty = 0;
                                                                        }
                                                                       
                                                                       //Update Cartitem wrapper with STOCKSTATUS & QUANTITY
                                                                       if(STOCK_STATUS == 'Out of Stock'){ 
                                                                            CARTITEM_WRAPPER_DETAILS.ItemAvailabilityMessage =  'In-Stock';
																			CARTITEM_WRAPPER_DETAILS.cartItem.dbu_isInStock__c =  false;
                                                                       }else{
                                                                       		CARTITEM_WRAPPER_DETAILS.ItemAvailabilityMessage =  STOCK_STATUS;
																			CARTITEM_WRAPPER_DETAILS.cartItem.dbu_isInStock__c =  True; 
                                                                       }
                                                                       //CARTITEM_WRAPPER_DETAILS.qtyAvailable = availableQty;
                                                                       if(STOCK_STATUS == 'Partial In-Stock'){ 
                                                                            CARTITEM_WRAPPER_DETAILS.qtyAvailableForPartialInStock = availableQty;
                                                                            dbu_CallCCCartApi.isPartialAvailability = true;
																			CARTITEM_WRAPPER_DETAILS.ItemAvailabilityMessage = 'Partially In Stock';  
																			CARTITEM_WRAPPER_DETAILS.cartItem.dbu_isInStock__c =  false;                                                                         

                                                                       }
                                                                        
                                                                       
                                                                       //Set the date   
                                                                       string currentDate;
                                                                       if(STOCK_STATUS != null && string.isNotBlank(STOCK_STATUS) 
                                                                          && BRANCH_COUNTRY != null && string.isNotBlank(BRANCH_COUNTRY) 
                                                                          && BRANCH_CITY != null && string.isNotBlank(BRANCH_CITY) 
                                                                          && BRANCH_STATE != null && string.isNotBlank(BRANCH_STATE)){
																			currentDate =  calculatepickupdate(STOCK_STATUS, ORDER_FROM, BRANCH_CITY, BRANCH_STATE, BRANCH_COUNTRY);                                                                                                                                  
                                                                       }                                                                                                                         
                                                                       CARTITEM_WRAPPER_DETAILS.cartItem.dbu_Estimated_PickUp__c = currentDate;   
                                                                       
                                                                       return CARTITEM_WRAPPER_DETAILS;
                                                                   }
    
    
    public static string calculatepickupdate(string stockstatus, string zone, string BRANCH_CITY, string BRANCH_STATE, string BRANCH_COUNTRY){
        
        datetime CurrentDate = datetime.now();
        string EstimatedDate;
        datetime CurrendatewithTimezone;
        string branchTimezone;
                
        if(stockstatus != null && stockstatus != '' && (stockstatus == 'In-Stock' || stockstatus == 'Partial In-Stock' )){
        	//CHECK 3PM + HOLIDAY
        	    
            //Get selected branch timezone
            branchTimezone = getTimezonedetails(BRANCH_CITY ,BRANCH_STATE, BRANCH_COUNTRY);
            
            //Calculate branch time based on branch timezone
            CurrendatewithTimezone = calculateTimeBasedONTimezone(branchTimezone, CurrentDate);
            
              
            
            //Call the 3pm method for In-Stock/Partial In-Stock
            CurrendatewithTimezone = calculate3PM(CurrendatewithTimezone, branchTimezone);
            system.debug('CurrendatewithTimezone > ' + CurrendatewithTimezone);
            
                //******** START JUST FOR TESTING **************
                //CurrendatewithTimezone = CurrendatewithTimezone.addDays(-4);
                //CurrendatewithTimezone = datetime.now();
                //CurrendatewithTimezone = CurrendatewithTimezone.addDays(-15);
               	//system.debug('HACIENDA > ' + CurrendatewithTimezone);				
				//******** END JUST FOR TESTING **************          
            
            //call the holiday calculator for In-Stock/Partial In-Stock
            dateReturnWrapper calculateholidayinstance = holidayCalulator(null, null, CurrendatewithTimezone, BRANCH_COUNTRY, BRANCH_STATE, stockstatus, null);
            if(calculateholidayinstance.stockstatus == 'In-Stock' || calculateholidayinstance.stockstatus == 'Partial In-Stock'){
                
                //Call formatting date function as per wireframe for Instock 
                EstimatedDate = formatPickUpDate(null,null, calculateholidayinstance.singledate, calculateholidayinstance.stockstatus);
                
            }
            
        }
        else if(stockstatus != null && stockstatus != '' && (stockstatus == 'Out of Stock' )){
            //CHECK ONLY HOLIDAY            
                
                //Get selected branch timezone
                branchTimezone = getTimezonedetails(BRANCH_CITY ,BRANCH_STATE, BRANCH_COUNTRY);
                
                //Calculate branch time based on branch timezone
                CurrendatewithTimezone = calculateTimeBasedONTimezone(branchTimezone, CurrentDate);                
                
                //******** START JUST FOR TESTING **************
                //CurrendatewithTimezone = CurrendatewithTimezone.addDays(-4);
                //CurrendatewithTimezone = datetime.now();
                //CurrendatewithTimezone = CurrendatewithTimezone.addDays(-2);
               	//system.debug('HACIENDA > ' + CurrendatewithTimezone);				
				//******** END JUST FOR TESTING **************
                
                date startdate;
                date enddate;
                
                if(BRANCH_COUNTRY == 'US'){
                    if(zone != null && string.isNotBlank(zone)){    
                        if(zone == 'RDC' || zone == 'CPW' || zone == 'California CPW'){
                            startdate = (CurrendatewithTimezone.addDays(1)).date();
                            enddate = (CurrendatewithTimezone.addDays(3)).date();
                            
                            //call the holiday calculator for Out of stock RDC/CPW
                            dateReturnWrapper calculateholidayinstance = holidayCalulator(startdate, enddate, CurrendatewithTimezone, BRANCH_COUNTRY, BRANCH_STATE, stockstatus, zone);                    
                            if(calculateholidayinstance.stockstatus == 'Out of Stock'){
                                startdate = calculateholidayinstance.startdate;
                                enddate = calculateholidayinstance.enddate;                        
                            }  
                            
                            //Call formatting date function as per wireframe for Instock 
                            EstimatedDate = formatPickUpDate(startdate,enddate, null, calculateholidayinstance.stockstatus);  
                            
                        }else if(zone == 'MDC'){
                            startdate = (CurrendatewithTimezone.addDays(7)).date();
                            enddate = (CurrendatewithTimezone.addDays(10)).date();    
                            
                            //call the holiday calculator for Out of stock MDC
                            dateReturnWrapper calculateholidayinstance = holidayCalulator(startdate, enddate, CurrendatewithTimezone, BRANCH_COUNTRY, BRANCH_STATE, stockstatus, zone);                    
                            if(calculateholidayinstance.stockstatus == 'Out of Stock'){
                                startdate = calculateholidayinstance.startdate;
                                enddate = calculateholidayinstance.enddate;
                            }  
                            
                            //Call formatting date function as per wireframe for Instock 
                            EstimatedDate = formatPickUpDate(startdate,enddate, null, calculateholidayinstance.stockstatus);                     
                        }                    
                    }
                }
            else if(BRANCH_COUNTRY == 'CA'){
                    startdate = (CurrendatewithTimezone.addDays(7)).date();
                    enddate = (CurrendatewithTimezone.addDays(10)).date();   
                    
                    //call the holiday calculator for Out of stock MDC
                    dateReturnWrapper calculateholidayinstance = holidayCalulator(startdate, enddate, CurrendatewithTimezone, BRANCH_COUNTRY, BRANCH_STATE, stockstatus, null);                                        
                    
                    if(calculateholidayinstance.stockstatus == 'Out of Stock'){
                        startdate = calculateholidayinstance.startdate;
                        enddate = calculateholidayinstance.enddate;
                    }
                    
                    //Call formatting date function as per wireframe for Instock 
                    EstimatedDate = formatPickUpDate(startdate,enddate, null, calculateholidayinstance.stockstatus);                                         
                    
                }

        }
        
        return EstimatedDate;
    }
    
    public static dateReturnWrapper holidayCalulator(date startdate,date enddate, datetime orderedDate, string country, string state, string stockstatus, string branchZone){
        //only for testing 
        //state = 'Quebec';
        //country = 'US';               
        //stockstatus = 'Out of Stock';                     
        
        //orderedDate =  datetime.now();
        system.debug('orderedDate > ' + orderedDate);
        
        //startdate = ((datetime.now()).addDays(7)).date();
        system.debug('startdate ' + startdate);    
        
        //enddate = ((datetime.now()).addDays(10)).date();                                          
        system.debug('enddate' + enddate); 
        //only for testing 
        
        dateReturnWrapper returnwrapper = new dateReturnWrapper();
        
        //Out of the stock logic
        if(enddate != null && startdate != null && stockstatus=='Out of Stock'){
            date enddateforQuery = enddate + 60;   
            system.debug('enddateforQuery > ' + enddateforQuery); 		
			
            date refinedOrderedDate = orderedDate.date();
            system.debug('refinedOrderedDate > ' + refinedOrderedDate); 			
			
            date refinedOrderedDateforQuery = refinedOrderedDate - 1;
            system.debug('refinedOrderedDateforQuery> ' + refinedOrderedDateforQuery); 		

            Integer noOfDays = refinedOrderedDateforQuery.daysBetween( enddateforQuery );
            system.debug('noOfDays > ' + noOfDays);  
			
			//-- US REIN BEGINS
            if(country == 'US'){
                list<dbu_HolidaysList__c> holidaylist = new list<dbu_HolidaysList__c>();
                holidaylist = [SELECT ID, dbu_holidayDate__c FROM dbu_HolidaysList__c WHERE dbu_Country__c =: country ORDER BY dbu_holidayDate__c];  
                system.debug('US HLD > ' + holidaylist); 		
				
				Map<date,USHolidayStack> USHolidayStackedMap = new Map<date,USHolidayStack>();
				Map<date,USHolidayStack> USHolidayStackedMapSorted = new Map<date,USHolidayStack>();
				
				//holiday list iteration begins 
				if(holidaylist.size() > 0 ){
					for(dbu_HolidaysList__c eachHoliday : holidaylist){
						USHolidayStack eachHolidayStack = new USHolidayStack();
						
						
						eachHolidayStack.holidaydate = eachHoliday.dbu_holidayDate__c;
						eachHolidayStack.isHolidayRecord = true;
						
						//check if Holiday is weekend 
						Datetime currentdatedt = DateTime.newInstance(eachHoliday.dbu_holidayDate__c, Time.newInstance(0, 0, 0, 0));
						System.debug('currentdatedt : ' + currentdatedt);

						String currentdayOfWeek = currentdatedt.format('EEEE');
						System.debug('currentdayOfWeek : ' + currentdayOfWeek);  	
							
						eachHolidayStack.dayofweek = currentdayOfWeek;	
						
						//Check if weekend 
						if(currentdayOfWeek == 'Saturday' || currentdayOfWeek == 'Sunday'){
							eachHolidayStack.isWeekend = true;
						}else{
							eachHolidayStack.isWeekend = false;
						}
						
						USHolidayStackedMap.put(eachHoliday.dbu_holidayDate__c , eachHolidayStack);
						
					}
										
				}
				//holiday list iteration completed 
				
				
				//Begin iteration in the days between 
				for(integer i=1 ; i < noOfDays ; i++){
					
					date curdate = refinedOrderedDateforQuery + i;					
					system.debug('curdate > ' + curdate);					
					
					//check if date is weekend 	
					Datetime currentdatedt = DateTime.newInstance(curdate, Time.newInstance(0, 0, 0, 0));
					System.debug('currentdatedt : ' + currentdatedt);

					String currentdayOfWeek = currentdatedt.format('EEEE');
					System.debug('currentdayOfWeek : ' + currentdayOfWeek);  
					
					
					//Check if the date already exist in Map 
					if(USHolidayStackedMap.get(curdate) != null){
						//date already exist in Map						
					}
					else{
						//date nonexistant in Map - new date
						
						//Now check if date fall on weekend
						if(currentdayOfWeek == 'Saturday' || currentdayOfWeek == 'Sunday'){
							USHolidayStack eachdateStack = new USHolidayStack();							
							eachdateStack.holidaydate = curdate;
							eachdateStack.isHolidayRecord = false;
							eachdateStack.dayofweek = currentdayOfWeek;							
							eachdateStack.isWeekend = true;
							USHolidayStackedMap.put(curdate, eachdateStack);
						}else{
							USHolidayStack eachdateStack = new USHolidayStack();							
							eachdateStack.holidaydate = curdate;
							eachdateStack.isHolidayRecord = false;
							eachdateStack.dayofweek = currentdayOfWeek;							
							eachdateStack.isWeekend = false;
							USHolidayStackedMap.put(curdate, eachdateStack);							
						}						
					}					
					
				}
				//End iteration in the days between 
				
				
				//Perform sorting 
				list<date> UnSortedDateList = new list<date>();							
				UnSortedDateList = new list<date>(USHolidayStackedMap.keyset());
				
				list<date> SortedDateList = new list<date>();							
				if(UnSortedDateList.size() > 0){
					SortedDateList = UnSortedDateList;
                    SortedDateList.sort();
				}else{
					SortedDateList = new list<date>(USHolidayStackedMap.keyset());
				}
				
				//Rearrange the stackedMap based on sorted list
				if(SortedDateList.size() > 0){
					for(date eachdate : SortedDateList){
						if(USHolidayStackedMap.get(eachdate) != null){
							USHolidayStackedMapSorted.put(eachdate, (USHolidayStack)USHolidayStackedMap.get(eachdate));
						}
					}					
				}
				system.debug('UnSortedDateList > ' + UnSortedDateList);
				system.debug('UnSortedDateList size > ' + UnSortedDateList.size());
				system.debug('SortedDateList > ' + SortedDateList);
				system.debug('SortedDateList size > ' + SortedDateList.size());
				system.debug('USHolidayStackedMap > ' + USHolidayStackedMap);
				system.debug('USHolidayStackedMapSorted > ' + USHolidayStackedMapSorted);

				//Begin Holiday Calculation				
				//Flag set for stop calculation
				boolean StopCalculate = false;
				
				for(date eachdate : SortedDateList){
					
					//3 TIERS DATE PROCESSING 
					
					//TIER 1 : LESS THAN OR EQUAL TO START DATE & GREATER THAN OR EQUAL TO ORDERED DATE
					if(eachdate <= startdate && eachdate >= refinedOrderedDate){
                        
						if(StopCalculate == false){
                            system.debug('INSIDE TIER 1 > ' + eachdate);
							if(USHolidayStackedMapSorted.get(eachdate) != null){
								USHolidayStack currentStack = new USHolidayStack();
								currentStack = (USHolidayStack)USHolidayStackedMapSorted.get(eachdate);

								//check if holiday & weekend
								if(currentStack.isHolidayRecord != null && currentStack.isWeekend != null && currentStack.isHolidayRecord == true && currentStack.isWeekend == true){
									system.debug('11 > ' + eachdate);
                                    startdate = startdate + 1;
									enddate = enddate + 1;
								}
								
								//check if only holiday
								if(currentStack.isHolidayRecord != null && currentStack.isWeekend != null && currentStack.isHolidayRecord == true && currentStack.isWeekend == false){
									system.debug('10 > ' + eachdate);
                                    startdate = startdate + 1;
									enddate = enddate + 1;								
								}	
								
								//check if only weekend							
                                if(currentStack.isHolidayRecord != null && currentStack.isWeekend != null && currentStack.isHolidayRecord == false && currentStack.isWeekend == true){
                                    system.debug('01 > ' + eachdate);
                                    if(branchZone == 'MDC'){
                                        startdate = startdate + 1;
                                        enddate = enddate + 1;                                          
                                    }
                                    if(branchZone == 'RDC' || branchZone == 'CPW' || branchZone == 'California CPW'){
										if(eachdate == refinedOrderedDate && currentStack.dayofweek != null && currentStack.dayofweek == 'Saturday'){
											system.debug('DONT ADD THE SATURDAY DAY IN START DATE & END DATE');
										}else if(currentStack.dayofweek != null){
											startdate = startdate + 1;
                                            enddate = enddate + 1;  
										}                                       
                                    }
                                    
								}								
								
							}

						}
					}
					//TIER 2 : GREATER THAN STARTDATE AND LESS THAN END DATE
					else if(eachdate > startdate && eachdate < enddate){
						if(StopCalculate == false){
							if(USHolidayStackedMapSorted.get(eachdate) != null){
                                system.debug('INSIDE TIER 2 > ' + eachdate);
								USHolidayStack currentStack = new USHolidayStack();
								currentStack = (USHolidayStack)USHolidayStackedMapSorted.get(eachdate);

								//check if holiday & weekend
								if(currentStack.isHolidayRecord != null && currentStack.isWeekend != null && currentStack.isHolidayRecord == true && currentStack.isWeekend == true){
									system.debug('11 > ' + eachdate);
                                    enddate = enddate + 1;
								}
								
								//check if only holiday
								if(currentStack.isHolidayRecord != null && currentStack.isWeekend != null && currentStack.isHolidayRecord == true && currentStack.isWeekend == false){
									system.debug('10 > ' + eachdate);
                                    enddate = enddate + 1;								
								}	
								
								//check if only weekend							
								if(currentStack.isHolidayRecord != null && currentStack.isWeekend != null && currentStack.isHolidayRecord == false && currentStack.isWeekend == true){
									system.debug('01 > ' + eachdate);
                                    enddate = enddate + 1;								
								}								
								
							}
						}
					}
					//TIER 3 : GREATER THAN ENDDATE OR EQUAL TO END DATE
					else if(eachdate >= enddate){
						
						if(StopCalculate == false){
							
							if(USHolidayStackedMapSorted.get(eachdate) != null){
								system.debug('INSIDE TIER 3 > ' + eachdate);
                                USHolidayStack currentStack = new USHolidayStack();
								currentStack = (USHolidayStack)USHolidayStackedMapSorted.get(eachdate);

								//check if holiday & weekend
								if(currentStack.isHolidayRecord != null && currentStack.isWeekend != null && currentStack.isHolidayRecord == true && currentStack.isWeekend == true){
									system.debug('11 > ' + eachdate);
                                    enddate = enddate + 1;
								}
								
								//check if only holiday
								if(currentStack.isHolidayRecord != null && currentStack.isWeekend != null && currentStack.isHolidayRecord == true && currentStack.isWeekend == false){
									system.debug('10 > ' + eachdate);
                                    enddate = enddate + 1;								
								}	
								
								//check if only weekend							
								if(currentStack.isHolidayRecord != null && currentStack.isWeekend != null && currentStack.isHolidayRecord == false && currentStack.isWeekend == true){
									system.debug('01 > ' + eachdate);
                                    enddate = enddate + 1;								
								}

								//check if its not a holiday & not a weekend			
								if(currentStack.isHolidayRecord != null && currentStack.isWeekend != null && currentStack.isHolidayRecord == false && currentStack.isWeekend == false){
									StopCalculate = true;						
								}									
								
							}							
	
						}
						
					}
					
				}
				
				system.debug('startdate > ' + startdate);
				system.debug('enddate > ' + enddate);
				
				
                returnwrapper.stockstatus = stockstatus;	
                returnwrapper.enddate = enddate;
                returnwrapper.startdate = startdate; 				
				
			}
            
			//-- US REIN ENDS

			//-- CANADA REIN BEGINS
            if(country == 'CA' && state != null && state != ''){
                list<dbu_HolidaysList__c> holidaylist = new list<dbu_HolidaysList__c>();
				
                holidaylist = [SELECT ID, dbu_holidayDate__c, dbu_ProvincesExcluded__c, dbu_ProvincesIncluded__c 
                               FROM dbu_HolidaysList__c WHERE dbu_Country__c =: country ORDER BY dbu_holidayDate__c];
                system.debug('CA HLD > ' + holidaylist); 
						
				
				Map<date,canadaHolidayStack> CAHolidayStackedMap = new Map<date,canadaHolidayStack>();
				Map<date,canadaHolidayStack> CAHolidayStackedMapSorted = new Map<date,canadaHolidayStack>();
				
				//holiday list iteration begins 
				if(holidaylist.size() > 0 ){
					for(dbu_HolidaysList__c eachHoliday : holidaylist){
						canadaHolidayStack eachHolidayStack = new canadaHolidayStack();
						
						
						eachHolidayStack.holidaydate = eachHoliday.dbu_holidayDate__c;
						eachHolidayStack.isHolidayRecord = true;
						
						if(eachHoliday.dbu_ProvincesIncluded__c != null && string.isNotBlank(eachHoliday.dbu_ProvincesIncluded__c)){
							eachHolidayStack.provinceIncluded = eachHoliday.dbu_ProvincesIncluded__c;
						}else{
							eachHolidayStack.provinceIncluded = null;
						}
						
						if(eachHoliday.dbu_ProvincesExcluded__c != null && string.isNotBlank(eachHoliday.dbu_ProvincesExcluded__c)){
							eachHolidayStack.proviceExluded = eachHoliday.dbu_ProvincesExcluded__c;
						}else{
							eachHolidayStack.proviceExluded = null;
						}						
						
						//check if Holiday is weekend 
						Datetime currentdatedt = DateTime.newInstance(eachHoliday.dbu_holidayDate__c, Time.newInstance(0, 0, 0, 0));
						System.debug('currentdatedt : ' + currentdatedt);

						String currentdayOfWeek = currentdatedt.format('EEEE');
						System.debug('currentdayOfWeek : ' + currentdayOfWeek);  	
							
						eachHolidayStack.dayofweek = currentdayOfWeek;	
						
						//Check if weekend 
						if(currentdayOfWeek == 'Saturday' || currentdayOfWeek == 'Sunday'){
							eachHolidayStack.isWeekendrecord = true;
						}else{
							eachHolidayStack.isWeekendrecord = false;
						}
						
						CAHolidayStackedMap.put(eachHoliday.dbu_holidayDate__c , eachHolidayStack);
						
					}
										
				}
				//holiday list iteration completed 
				
				
				//Begin iteration in the days between 
				for(integer i=1 ; i < noOfDays ; i++){
					
					date curdate = refinedOrderedDateforQuery + i;					
					system.debug('curdate > ' + curdate);					
					
					//check if date is weekend 	
					Datetime currentdatedt = DateTime.newInstance(curdate, Time.newInstance(0, 0, 0, 0));
					System.debug('currentdatedt : ' + currentdatedt);

					String currentdayOfWeek = currentdatedt.format('EEEE');
					System.debug('currentdayOfWeek : ' + currentdayOfWeek);  
					
					
					//Check if the date already exist in Map 
					if(CAHolidayStackedMap.get(curdate) != null){
						//date already exist in Map						
					}
					else{
						//date nonexistant in Map - new date
						
						//Now check if date fall on weekend
						if(currentdayOfWeek == 'Saturday' || currentdayOfWeek == 'Sunday'){
							canadaHolidayStack eachdateStack = new canadaHolidayStack();							
							eachdateStack.holidaydate = curdate;
							eachdateStack.isHolidayRecord = false;
							eachdateStack.dayofweek = currentdayOfWeek;							
							eachdateStack.isWeekendrecord = true;
							eachdateStack.proviceExluded = null;
							eachdateStack.provinceIncluded = null;
							CAHolidayStackedMap.put(curdate, eachdateStack);
						}else{
							canadaHolidayStack eachdateStack = new canadaHolidayStack();							
							eachdateStack.holidaydate = curdate;
							eachdateStack.isHolidayRecord = false;
							eachdateStack.dayofweek = currentdayOfWeek;							
							eachdateStack.isWeekendrecord = false;
							eachdateStack.proviceExluded = null;
							eachdateStack.provinceIncluded = null;							
							CAHolidayStackedMap.put(curdate, eachdateStack);							
						}						
					}					
					
				}
				//End iteration in the days between 
				
				
				//Perform sorting 
				list<date> UnSortedDateList = new list<date>();							
				UnSortedDateList = new list<date>(CAHolidayStackedMap.keyset());
				
				list<date> SortedDateList = new list<date>();							
				if(UnSortedDateList.size() > 0){
					SortedDateList = UnSortedDateList;
                    SortedDateList.sort();
				}else{
					SortedDateList = new list<date>(CAHolidayStackedMap.keyset());
				}
				
				//Rearrange the stackedMap based on sorted list
				if(SortedDateList.size() > 0){
					for(date eachdate : SortedDateList){
						if(CAHolidayStackedMap.get(eachdate) != null){
							CAHolidayStackedMapSorted.put(eachdate, (canadaHolidayStack)CAHolidayStackedMap.get(eachdate));
						}
					}					
				}
				system.debug('UnSortedDateList > ' + UnSortedDateList);
				system.debug('UnSortedDateList size > ' + UnSortedDateList.size());
				system.debug('SortedDateList > ' + SortedDateList);
				system.debug('SortedDateList size > ' + SortedDateList.size());
				system.debug('CAHolidayStackedMap > ' + CAHolidayStackedMap);
				system.debug('CAHolidayStackedMapSorted > ' + CAHolidayStackedMapSorted);
                system.debug('CAHolidayStackedMapSorted jsa > ' + JSON.serializePretty(CAHolidayStackedMapSorted));

				//Begin Holiday Calculation				
				//Flag set for stop calculation
				boolean StopCalculate = false;
				
				for(date eachdate : SortedDateList){
					
					//3 TIERS DATE PROCESSING 
					
					//TIER 1 : LESS THAN OR EQUAL TO START DATE & GREATER THAN OR EQUAL TO ORDERED DATE
					if(eachdate <= startdate && eachdate >= refinedOrderedDate){
                        
						if(StopCalculate == false){
                            system.debug('INSIDE TIER 1 > ' + eachdate);
							if(CAHolidayStackedMapSorted.get(eachdate) != null){
								canadaHolidayStack currentStack = new canadaHolidayStack();
								currentStack = (canadaHolidayStack)CAHolidayStackedMapSorted.get(eachdate);


								//check if holiday & weekend
								if(currentStack.isHolidayRecord != null && currentStack.isWeekendrecord != null && currentStack.isHolidayRecord == true && currentStack.isWeekendrecord == true){
									
									boolean excludeflag = false;
									boolean includeflag = false;									
									
									//check if holiday falls in exluded or included
									if(currentStack.proviceExluded != null && string.isNotBlank(currentStack.proviceExluded)){                                    
										if((currentStack.proviceExluded).contains(state)){
											excludeflag = true;
										}
									}
									
									//check if holiday falls in exluded or included
									if(currentStack.provinceIncluded != null && string.isNotBlank(currentStack.provinceIncluded)){                                    
										if((currentStack.provinceIncluded).contains(state) || 
                                           (currentStack.provinceIncluded).contains('all') || 
                                           (currentStack.provinceIncluded).contains('All') || 
                                           (currentStack.provinceIncluded).contains('ALL') || 
                                           (currentStack.provinceIncluded).contains('aLL')){
											includeflag = true;
										}
									}
									
                                    system.debug('includeflag > ' + includeflag);
                                    system.debug('excludeflag > ' + excludeflag);
                                    
									if(excludeflag == false && includeflag == true){
										// yes its a holiday
										system.debug('11 > ' + eachdate);
										startdate = startdate + 1;
										enddate = enddate + 1;										
									}else{
										//Not holiday but a week end
										system.debug('11 > ' + eachdate);
										startdate = startdate + 1;
										enddate = enddate + 1;										
									}
									

								}
								
								//check if only holiday
								if(currentStack.isHolidayRecord != null && currentStack.isWeekendrecord != null && currentStack.isHolidayRecord == true && currentStack.isWeekendrecord == false){
									
									boolean excludeflag = false;
									boolean includeflag = false;									
									
									//check if holiday falls in exluded or included
									if(currentStack.proviceExluded != null && string.isNotBlank(currentStack.proviceExluded)){                                    
										if((currentStack.proviceExluded).contains(state)){
											excludeflag = true;
										}
									}
									
									//check if holiday falls in exluded or included
									if(currentStack.provinceIncluded != null && string.isNotBlank(currentStack.provinceIncluded)){                                    
										if((currentStack.provinceIncluded).contains(state) || 
                                           (currentStack.provinceIncluded).contains('all') || 
                                           (currentStack.provinceIncluded).contains('All') || 
                                           (currentStack.provinceIncluded).contains('ALL') || 
                                           (currentStack.provinceIncluded).contains('aLL')){
											includeflag = true;
										}
									}	

									if(excludeflag == false && includeflag == true){
										// yes its a holiday
										system.debug('10 > ' + eachdate);
										startdate = startdate + 1;
										enddate = enddate + 1;										
									}									
																										
								}	
								
								//check if only weekend							
								if(currentStack.isHolidayRecord != null && currentStack.isWeekendrecord != null && currentStack.isHolidayRecord == false && currentStack.isWeekendrecord == true){
									
									system.debug('01 > ' + eachdate);
                                    startdate = startdate + 1;
									enddate = enddate + 1;	
									
								}																
							}

						}
					}
					//TIER 2 : GREATER THAN STARTDATE AND LESS THAN END DATE
					else if(eachdate > startdate && eachdate < enddate){
						if(StopCalculate == false){
							if(CAHolidayStackedMapSorted.get(eachdate) != null){
                                system.debug('INSIDE TIER 2 > ' + eachdate);
								canadaHolidayStack currentStack = new canadaHolidayStack();
								currentStack = (canadaHolidayStack)CAHolidayStackedMapSorted.get(eachdate);

								//check if holiday & weekend
								if(currentStack.isHolidayRecord != null && currentStack.isWeekendrecord != null && currentStack.isHolidayRecord == true && currentStack.isWeekendrecord == true){
									
									boolean excludeflag = false;
									boolean includeflag = false;									
									
									//check if holiday falls in exluded or included
									if(currentStack.proviceExluded != null && string.isNotBlank(currentStack.proviceExluded)){                                    
										if((currentStack.proviceExluded).contains(state)){
											excludeflag = true;
										}
									}
									
									//check if holiday falls in exluded or included
									if(currentStack.provinceIncluded != null && string.isNotBlank(currentStack.provinceIncluded)){                                    
										if((currentStack.provinceIncluded).contains(state) || 
                                           (currentStack.provinceIncluded).contains('all') || 
                                           (currentStack.provinceIncluded).contains('All') || 
                                           (currentStack.provinceIncluded).contains('ALL') || 
                                           (currentStack.provinceIncluded).contains('aLL')){
											includeflag = true;
										}
									}

                                    system.debug('includeflag > ' + includeflag);
                                    system.debug('excludeflag > ' + excludeflag);                                    
                                    
									if(excludeflag == false && includeflag == true){
										// yes its a holiday
										system.debug('11 > ' + eachdate);
										enddate = enddate + 1;										
									}else{
										//Not holiday but a week end
										system.debug('11 > ' + eachdate);										
										enddate = enddate + 1;										
									}																		
								}
								
								//check if only holiday
								if(currentStack.isHolidayRecord != null && currentStack.isWeekendrecord != null && currentStack.isHolidayRecord == true && currentStack.isWeekendrecord == false){
									
									boolean excludeflag = false;
									boolean includeflag = false;									
									
									//check if holiday falls in exluded or included
									if(currentStack.proviceExluded != null && string.isNotBlank(currentStack.proviceExluded)){                                    
										if((currentStack.proviceExluded).contains(state)){
											excludeflag = true;
										}
									}
									
									//check if holiday falls in exluded or included
									if(currentStack.provinceIncluded != null && string.isNotBlank(currentStack.provinceIncluded)){                                    
										if((currentStack.provinceIncluded).contains(state) || 
                                           (currentStack.provinceIncluded).contains('all') || 
                                           (currentStack.provinceIncluded).contains('All') || 
                                           (currentStack.provinceIncluded).contains('ALL') || 
                                           (currentStack.provinceIncluded).contains('aLL')){
											includeflag = true;
										}
									}

									if(excludeflag == false && includeflag == true){
										// yes its a holiday
										system.debug('10 > ' + eachdate);
										enddate = enddate + 1;										
									}										
									
								}	
								
								//check if only weekend							
								if(currentStack.isHolidayRecord != null && currentStack.isWeekendrecord != null && currentStack.isHolidayRecord == false && currentStack.isWeekendrecord == true){
									system.debug('01 > ' + eachdate);
                                    enddate = enddate + 1;								
								}								
								
							}
						}
					}
					//TIER 3 : GREATER THAN ENDDATE OR EQUAL TO END DATE
					else if(eachdate >= enddate){
						
						if(StopCalculate == false){
							
							if(CAHolidayStackedMapSorted.get(eachdate) != null){
								system.debug('INSIDE TIER 3 > ' + eachdate);
                                canadaHolidayStack currentStack = new canadaHolidayStack();
								currentStack = (canadaHolidayStack)CAHolidayStackedMapSorted.get(eachdate);

								//check if holiday & weekend
								if(currentStack.isHolidayRecord != null && currentStack.isWeekendrecord != null && currentStack.isHolidayRecord == true && currentStack.isWeekendrecord == true){
									
									boolean excludeflag = false;
									boolean includeflag = false;									
									
									//check if holiday falls in exluded or included
									if(currentStack.proviceExluded != null && string.isNotBlank(currentStack.proviceExluded)){                                    
										if((currentStack.proviceExluded).contains(state)){
											excludeflag = true;
										}
									}
									
									//check if holiday falls in exluded or included
									if(currentStack.provinceIncluded != null && string.isNotBlank(currentStack.provinceIncluded)){                                    
										if((currentStack.provinceIncluded).contains(state) || 
                                           (currentStack.provinceIncluded).contains('all') || 
                                           (currentStack.provinceIncluded).contains('All') || 
                                           (currentStack.provinceIncluded).contains('ALL') || 
                                           (currentStack.provinceIncluded).contains('aLL')){
											includeflag = true;
										}
									}

                                    system.debug('includeflag > ' + includeflag);
                                    system.debug('excludeflag > ' + excludeflag);                                    
                                    
									if(excludeflag == false && includeflag == true){
										// yes its a holiday
										system.debug('11 > ' + eachdate);
										enddate = enddate + 1;										
									}else{
										//Not holiday but a week end
										system.debug('11 > ' + eachdate);										
										enddate = enddate + 1;										
									}										
									

								}
								
								//check if only holiday
								if(currentStack.isHolidayRecord != null && currentStack.isWeekendrecord != null && currentStack.isHolidayRecord == true && currentStack.isWeekendrecord == false){
									
									boolean excludeflag = false;
									boolean includeflag = false;									
									
									//check if holiday falls in exluded or included
									if(currentStack.proviceExluded != null && string.isNotBlank(currentStack.proviceExluded)){                                    
										if((currentStack.proviceExluded).contains(state)){
											excludeflag = true;
										}
									}
									
									//check if holiday falls in exluded or included
									if(currentStack.provinceIncluded != null && string.isNotBlank(currentStack.provinceIncluded)){                                    
										if((currentStack.provinceIncluded).contains(state) || 
                                           (currentStack.provinceIncluded).contains('all') || 
                                           (currentStack.provinceIncluded).contains('All') || 
                                           (currentStack.provinceIncluded).contains('ALL') || 
                                           (currentStack.provinceIncluded).contains('aLL')){
											includeflag = true;
										}
									}

									if(excludeflag == false && includeflag == true){
										// yes its a holiday
										system.debug('10 > ' + eachdate);
										enddate = enddate + 1;										
									}										
																
								}	
								
								//check if only weekend							
								if(currentStack.isHolidayRecord != null && currentStack.isWeekendrecord != null && currentStack.isHolidayRecord == false && currentStack.isWeekendrecord == true){
									system.debug('01 > ' + eachdate);
                                    enddate = enddate + 1;								
								}

								//check if its not a holiday & not a weekend			
								if(currentStack.isHolidayRecord != null && currentStack.isWeekendrecord != null && currentStack.isHolidayRecord == false && currentStack.isWeekendrecord == false){
									StopCalculate = true;						
								}									
								
							}							
	
						}
						
					}
					
				}
				
				system.debug('startdate > ' + startdate);
				system.debug('enddate > ' + enddate);
				
				
                returnwrapper.stockstatus = stockstatus;	
                returnwrapper.enddate = enddate;
                returnwrapper.startdate = startdate; 				
				
			}            			
			//-- CANADA REIN ENDS

			
			
		}
		//Out of the stock logic -ENDS
        
        //Instock logic
        else if(stockstatus=='In-Stock' || stockstatus == 'Partial In-Stock'){
            
            date refinedOrderedDate = orderedDate.date();
            system.debug('refinedOrderedDate > ' + refinedOrderedDate); 
            
			date OriginalOrderedDate = orderedDate.date();
			system.debug('OriginalOrderedDate > ' + OriginalOrderedDate); 			

            
               
            
            list<dbu_HolidaysList__c> holidaylist = new list<dbu_HolidaysList__c>();
			//--------------------------------------------------------------------------------------------
			if(country == 'US'){
                                
				holidaylist = [SELECT ID, dbu_holidayDate__c FROM dbu_HolidaysList__c WHERE dbu_Country__c =: country ORDER BY dbu_holidayDate__c];  
				system.debug('US HLD > ' + holidaylist); 
				
				list<date> holidaylistofdates = new list<date> ();
				Map<date,string> HolidayDateToDayMapping = new Map<date,string>();
				
				for(dbu_HolidaysList__c eachdate :  holidaylist){
					date currentdate = eachdate.dbu_holidayDate__c;
					
					Datetime refinedOrderedDatedt = DateTime.newInstance(currentdate, Time.newInstance(0, 0, 0, 0));
					System.debug('refinedOrderedDatedt : ' + refinedOrderedDatedt);
					
					String currentweekdayofRefinedorderDate = refinedOrderedDatedt.format('EEEE');
					System.debug('currentweekdayofRefinedorderDate : ' + currentweekdayofRefinedorderDate);	
					
					holidaylistofdates.add(currentdate);
					HolidayDateToDayMapping.put(currentdate, currentweekdayofRefinedorderDate);
				}
				system.debug('holidaylistofdates > '  + holidaylistofdates);
				
				for(integer i=1; i<=20; i++){
					date currenthldate = OriginalOrderedDate + i;
					Datetime refinedOrderedDatedt = DateTime.newInstance(currenthldate, Time.newInstance(0, 0, 0, 0));
					System.debug('refinedOrderedDatedt : ' + refinedOrderedDatedt);
					
					String currentweekdayofRefinedorderDate = refinedOrderedDatedt.format('EEEE');
					System.debug('currentweekdayofRefinedorderDate : ' + currentweekdayofRefinedorderDate);	
					
					if(currentweekdayofRefinedorderDate == 'Saturday'){
						holidaylistofdates.add(currenthldate);
						HolidayDateToDayMapping.put(currenthldate, currentweekdayofRefinedorderDate);
					}
					
					if(currentweekdayofRefinedorderDate == 'Sunday'){
						holidaylistofdates.add(currenthldate);
						HolidayDateToDayMapping.put(currenthldate, currentweekdayofRefinedorderDate);
					}
				}
				
				list<date> holidaylistofdatesSorted = new list<date>(new set<date>(holidaylistofdates));
				holidaylistofdatesSorted.sort();
				holidaylistofdates = holidaylistofdatesSorted;
				
				//8 may, 9 may 
				for(date eachdate : holidaylistofdates){ 
					
					Datetime refinedOrderedDatedt = DateTime.newInstance(refinedOrderedDate, Time.newInstance(0, 0, 0, 0));
					System.debug('refinedOrderedDatedt : ' + refinedOrderedDatedt);
					
					String currentweekdayofRefinedorderDate = refinedOrderedDatedt.format('EEEE');
					System.debug('currentweekdayofRefinedorderDate : ' + currentweekdayofRefinedorderDate);
				
					//Holiday found at refined order date
					if(refinedOrderedDate == eachdate){
						
						//sat-sun at refined order date
						if(currentweekdayofRefinedorderDate == 'Saturday' || currentweekdayofRefinedorderDate == 'Sunday'){	  

							//sat found
							if(currentweekdayofRefinedorderDate == 'Saturday'){
								refinedOrderedDate = refinedOrderedDate + 1;
								//daystoupdateinorderDate = daystoupdateinorderDate + 2;	
							}
							
							//sun found
							if(currentweekdayofRefinedorderDate == 'Sunday'){
								refinedOrderedDate = refinedOrderedDate + 1;
								//daystoupdateinorderDate = daystoupdateinorderDate + 1;	
							}
						}
						//no sat sun at order date but holiday found
						else if(currentweekdayofRefinedorderDate != 'Saturday' && currentweekdayofRefinedorderDate != 'Sunday'){
							refinedOrderedDate = refinedOrderedDate + 1;
						}			
						
					}else{
						//No Holiday at refined order date			
						//But need to check if sat sun at refined order date
						if(currentweekdayofRefinedorderDate == 'Saturday' || currentweekdayofRefinedorderDate == 'Sunday'){	  

							//sat found
							if(currentweekdayofRefinedorderDate == 'Saturday'){
								refinedOrderedDate = refinedOrderedDate + 1;
								//daystoupdateinorderDate = daystoupdateinorderDate + 2;	
							}
							
							//sun found
							if(currentweekdayofRefinedorderDate == 'Sunday'){
								refinedOrderedDate = refinedOrderedDate + 1;
								//daystoupdateinorderDate = daystoupdateinorderDate + 1;	
							}
						}			
					}

				}
					

				returnwrapper.stockstatus = stockstatus;	
				returnwrapper.singledate = refinedOrderedDate;	
				

				}
			//--------------------------------------------------------------------------------------------
			else if(country == 'CA' && state != null && state != ''){
					holidaylist = [SELECT ID, dbu_holidayDate__c, dbu_ProvincesExcluded__c, dbu_ProvincesIncluded__c
								   FROM dbu_HolidaysList__c WHERE dbu_Country__c =: country ORDER BY dbu_holidayDate__c];	
								   
								   
					system.debug('CA HLD > ' + holidaylist);
					list<canadaHolidayStack> canadaHolidayStackList = new list<canadaHolidayStack>();
					list<date> canadaHolidayDateList = new list<date>();
                	Map<date, canadaHolidayStack> canadaHolidayStackMap = new Map<date, canadaHolidayStack>();
						for(dbu_HolidaysList__c eachHoliday : holidaylist){
							canadaHolidayStack eachcanadaHolidayStack = new canadaHolidayStack();
							eachcanadaHolidayStack.holidaydate = eachHoliday.dbu_holidayDate__c;
							
							if(eachHoliday.dbu_ProvincesIncluded__c != null){
								eachcanadaHolidayStack.provinceIncluded = eachHoliday.dbu_ProvincesIncluded__c;
							}else{
								eachcanadaHolidayStack.provinceIncluded = null;
							}
							
							if(eachHoliday.dbu_ProvincesExcluded__c != null){
								eachcanadaHolidayStack.proviceExluded = eachHoliday.dbu_ProvincesExcluded__c;
							}else{
								eachcanadaHolidayStack.proviceExluded = null;
							}
											
							eachcanadaHolidayStack.isWeekendrecord = false;
							
							Datetime currentdatedt = DateTime.newInstance(eachHoliday.dbu_holidayDate__c, Time.newInstance(0, 0, 0, 0));
							//System.debug('currentdatedt : ' + currentdatedt);
							
							String currentweekdayofcurrentdatedt = currentdatedt.format('EEEE');
							//System.debug('currentweekdayofcurrentdatedt : ' + currentweekdayofcurrentdatedt);				
							
							eachcanadaHolidayStack.dayofweek = currentweekdayofcurrentdatedt;
                            system.debug('TULA HOLIDAY > ' + eachHoliday.dbu_holidayDate__c);
							canadaHolidayDateList.add(eachHoliday.dbu_holidayDate__c);				
							canadaHolidayStackList.add(eachcanadaHolidayStack);
                            canadaHolidayStackMap.put(eachHoliday.dbu_holidayDate__c, eachcanadaHolidayStack);
						}
								
						for(integer i=1; i<=20; i++){
							canadaHolidayStack eachcanadaHolidayStack = new canadaHolidayStack();
							date currenthldate = OriginalOrderedDate + i;
							Datetime refinedOrderedDatedt = DateTime.newInstance(currenthldate, Time.newInstance(0, 0, 0, 0));
							//System.debug('refinedOrderedDatedt : ' + refinedOrderedDatedt);
							
							String currentweekdayofRefinedorderDate = refinedOrderedDatedt.format('EEEE');
							//System.debug('currentweekdayofRefinedorderDate : ' + currentweekdayofRefinedorderDate);	
							
							if(currentweekdayofRefinedorderDate == 'Saturday'){
								eachcanadaHolidayStack.holidaydate = currenthldate;
								eachcanadaHolidayStack.provinceIncluded = null;
								eachcanadaHolidayStack.proviceExluded = null;
								eachcanadaHolidayStack.isWeekendrecord = true;
								eachcanadaHolidayStack.dayofweek = currentweekdayofRefinedorderDate;
                                canadaHolidayStackList.add(eachcanadaHolidayStack);
                                canadaHolidayDateList.add(currenthldate);
                                if(canadaHolidayStackMap.get(currenthldate) == null){
                                    canadaHolidayStackMap.put(currenthldate, eachcanadaHolidayStack);
                                }
                                system.debug('AMUR SAT > ' + currenthldate);
							}
							
							if(currentweekdayofRefinedorderDate == 'Sunday'){
								eachcanadaHolidayStack.holidaydate = currenthldate;
								eachcanadaHolidayStack.provinceIncluded = null;
								eachcanadaHolidayStack.proviceExluded = null;
								eachcanadaHolidayStack.isWeekendrecord = true;
								eachcanadaHolidayStack.dayofweek = currentweekdayofRefinedorderDate;
                                canadaHolidayStackList.add(eachcanadaHolidayStack);
                                canadaHolidayDateList.add(currenthldate);
                                if(canadaHolidayStackMap.get(currenthldate) == null){
                                    canadaHolidayStackMap.put(currenthldate, eachcanadaHolidayStack);
                                }                                
								system.debug('AMUR SUN > ' + currenthldate);                                
							}
														                            
						}	
						system.Debug('canadaHolidayStackList before sort > ' + canadaHolidayStackList);
                
						//performing Manual sorting
						list<canadaHolidayStack> canadaHolidayStackListSorted = new list<canadaHolidayStack>();
                        if(canadaHolidayStackList.size() > 0){
                            system.Debug('canadaHolidayDateList before duplicates remove > ' + JSON.serializePretty(canadaHolidayDateList));
                            //removing duplicates
                            canadaHolidayDateList = new list<date>(new set<date>(canadaHolidayDateList));
                            system.Debug('canadaHolidayDateList after duplicates remove > ' + JSON.serializePretty(canadaHolidayDateList));
                            canadaHolidayDateList.sort();
                            
                            for(date eachdate : canadaHolidayDateList){
                                if(canadaHolidayStackMap.get(eachdate) != null){
                                    canadaHolidayStackListSorted.add((canadaHolidayStack)canadaHolidayStackMap.get(eachdate));
                                }	   
                            }
                        }
                        //system.debug('canadaHolidayStackListSorted > ' + JSON.serializePretty(canadaHolidayStackListSorted));                
                        system.debug('canadaHolidayStackListSorted > ' + canadaHolidayStackListSorted.size());                
                        //system.Debug('canadaHolidayStackMap > ' + JSON.serializePretty(canadaHolidayStackMap)); 
                		system.Debug('canadaHolidayStackMap > ' + canadaHolidayStackMap.size());
                        //system.Debug('canadaHolidayDateList after sort > ' + JSON.serializePretty(canadaHolidayDateList));
                		system.Debug('canadaHolidayDateList after sort > ' + canadaHolidayDateList.size());
                        
                        
                		canadaHolidayStackList = canadaHolidayStackListSorted;
                		//system.Debug('canadaHolidayStackList after sort > ' + JSON.serializePretty(canadaHolidayStackList));
						system.Debug('canadaHolidayStackList after sort > ' + canadaHolidayStackList.size());                	
                
                        for(canadaHolidayStack eachitem  : canadaHolidayStackList){
							
							Datetime refinedOrderedDatedt = DateTime.newInstance(refinedOrderedDate, Time.newInstance(0, 0, 0, 0));
							System.debug('refinedOrderedDatedt : ' + refinedOrderedDatedt);
							
							String currentweekdayofRefinedorderDate = refinedOrderedDatedt.format('EEEE');
							System.debug('currentweekdayofRefinedorderDate : ' + currentweekdayofRefinedorderDate);				
							
							//Holiday found at refined order date
							if(refinedOrderedDate == eachitem.holidaydate){
								
								//Check the exclusions
								boolean excludeflag = false;
								boolean includeflag = false;					
								
								//If date has province excluded in it 
								if(eachitem.proviceExluded != null && string.isNotBlank(eachitem.proviceExluded)){
									if((eachitem.proviceExluded).contains(state)){                                                                
										excludeflag = true;
									}
								}

								//Check the Inclusions
								system.debug(eachitem.provinceIncluded);
								system.debug(state);
								if(eachitem.provinceIncluded != null && string.isNotBlank(eachitem.provinceIncluded)){
									if((eachitem.provinceIncluded).contains(state) || (eachitem.provinceIncluded).contains('all') || (eachitem.provinceIncluded).contains('All') || (eachitem.provinceIncluded).contains('ALL')){
										system.debug('instock canada > includeflag = true');
										includeflag = true;
									}                                                                                           
								}
								
								// Yes holiday found based on the province check
								if(excludeflag == false && includeflag == true){                                
									
									//check if the holiday is sat-sun
									if(eachitem.dayofweek == 'Saturday' || eachitem.dayofweek == 'Sunday'){	
										
										//sat found
										if(eachitem.dayofweek == 'Saturday'){
											refinedOrderedDate = refinedOrderedDate + 1;								
										}
										
										//sun found
										if(eachitem.dayofweek == 'Sunday'){
											refinedOrderedDate = refinedOrderedDate + 1;								
										}							
										
									}
									//no sat sun at order date but holiday found
									else if(eachitem.dayofweek != 'Saturday' && eachitem.dayofweek != 'Sunday'){
										refinedOrderedDate = refinedOrderedDate + 1;
									}						
									
									//refinedOrderedDate =  (datetime.newInstance(refinedOrderedDate.year(),refinedOrderedDate.month(),refinedOrderedDate.day()).addDays(1)).date();                        							                            
									system.debug('instock canada > refinedOrderedDate ' + refinedOrderedDate);
								}
								else{
									//No holiday due to the provice, but can be a weekend(sat-sun)
									//check if the day is sat-sun
									if(eachitem.dayofweek == 'Saturday' || eachitem.dayofweek == 'Sunday'){	
										
										//sat found
										if(eachitem.dayofweek == 'Saturday'){
											refinedOrderedDate = refinedOrderedDate + 1;								
										}
										
										//sun found
										if(eachitem.dayofweek == 'Sunday'){
											refinedOrderedDate = refinedOrderedDate + 1;								
										}							
										
									}						
								}					
								
							}
							else{
								//No Holiday at refined order date	
								//But need to check if sat sun at refined order date
								if(currentweekdayofRefinedorderDate == 'Saturday' || currentweekdayofRefinedorderDate == 'Sunday'){	  

									//sat found
									if(currentweekdayofRefinedorderDate == 'Saturday'){
										refinedOrderedDate = refinedOrderedDate + 1;							
									}
									
									//sun found
									if(currentweekdayofRefinedorderDate == 'Sunday'){
										refinedOrderedDate = refinedOrderedDate + 1;
									}
									
								}					
							}
										
						}
						
						returnwrapper.stockstatus = stockstatus;	
						returnwrapper.singledate = refinedOrderedDate;			
										
			}   
			//--------------------------------------------------------------------------------------------
            
        }
		
		
        system.debug('returnwrapper > ' + returnwrapper);        
        return returnwrapper;                                 
    }
    
	
    public static datetime calculate3PM(datetime orderedDate, string branchTimezone){
        Datetime now = Datetime.now();
        String strConvertedDate23 = now.format('HH', branchTimezone);
        system.debug('nazarbaev23 >> ' + strConvertedDate23); 
        if(integer.valueOf(strConvertedDate23) >= 15 ){
          orderedDate =  orderedDate.addDays(1);
        }
        return orderedDate;
    }
    
    public static string getTimezonedetails(string StoreCity ,string StoreState, string storeCountry){
        
        //get respective timezone from cmdt
        list<dbu_StoreLocationTimezoneMapping__mdt> timezonemappinglist = new list<dbu_StoreLocationTimezoneMapping__mdt> ();
        timezonemappinglist = [SELECT ID, 
                               dbu_ApplicableTimezone__c, 
                               dbu_City__c, 
                               dbu_Country__c, 
                               dbu_GMTOffset__c, 
                               dbu_State__c 
                               FROM dbu_StoreLocationTimezoneMapping__mdt 
                               WHERE dbu_City__c =: StoreCity 
                               AND dbu_Country__c =: storeCountry 
                               AND dbu_State__c =: StoreState];
        
        string retrivedTimezone;
        if(timezonemappinglist.size() > 0){
            if(timezonemappinglist[0].dbu_ApplicableTimezone__c != null && string.isNotBlank(timezonemappinglist[0].dbu_ApplicableTimezone__c)){                
                retrivedTimezone = timezonemappinglist[0].dbu_ApplicableTimezone__c;                               
            }else{
                retrivedTimezone = 'GMT';
            }            
        }else{
            retrivedTimezone = 'GMT';
        }
        
		return retrivedTimezone;               		        
    }
    
    public static datetime calculateTimeBasedONTimezone(string TimezoneToBeconverted, Datetime datetimeToConvert){
        datetime calculatedDatetime;
        
        //Determine timezone
        TimeZone targetTZ = Timezone.getTimeZone(TimezoneToBeconverted);
        //get offset difference
        integer  offsetTotargetTZ = targetTZ.getOffset(datetimeToConvert);        
        system.debug('offsetTotargetTZ > ' + offsetTotargetTZ);
        //set new time
        DateTime newDateTime = datetimeToConvert.addSeconds(offsetTotargetTZ/1000);
        system.debug('newDateTime > ' + newDateTime);

		return  newDateTime;       
    }
    
                    
	public static string formatPickUpDate(date startdate,date enddate, date singledate, string stockstatus){
       string finalPickUpDate;
        
        if(stockstatus != null && stockstatus != '' && (stockstatus == 'In-Stock' || stockstatus == 'Partial In-Stock' )){
            if(singledate != null){
                integer currentMOnth = singledate.month();
                string thisMOnth = FetchMonth(currentMOnth);
                integer currentDay = singledate.day();
				string thisDay = string.valueOf(currentDay);                
                finalPickUpDate = thisMOnth + ' ' +  thisDay;
            }
            
        }else if(stockstatus != null && stockstatus != '' && (stockstatus == 'Out of Stock' )){
            if(startdate != null && enddate != null){
                //For startDate
                integer currentStartMOnth = startdate.month();
                string thisStartMOnth = FetchMonth(currentStartMOnth);
                integer currentStartDay = startdate.day();
                string thisStartDay = string.valueOf(currentStartDay);                
                
                
                //For EndDate
                integer currentEndMOnth = enddate.month();
                string thisEndMOnth = FetchMonth(currentEndMOnth);
                integer currentEndDay = enddate.day();
                string thisEndDay = string.valueOf(currentEndDay);                
                
                
                finalPickUpDate = thisStartMOnth + ' ' +  thisStartDay + ' - ' + thisEndMOnth + ' ' + thisEndDay;
            }
        }        

       return  finalPickUpDate;
    }        
        
    public static string FetchMonth(integer month){
        string MonthToReturn;
        if(month != null){
        if(month == 1 ){
            MonthToReturn = 'January';
        }
        else if(month == 2 ){
            MonthToReturn = 'February';
        }
        else if(month == 3 ){
            MonthToReturn = 'March';
        }
        else if(month == 4 ){
            MonthToReturn = 'April';
        }
        else if(month == 5 ){
            MonthToReturn = 'May';
        }
        else if(month == 6 ){
            MonthToReturn = 'June';
        }        
        else if(month == 7 ){
            MonthToReturn = 'July';
        }
        else if(month == 8 ){
            MonthToReturn = 'August';
        }
        else if(month == 9 ){
            MonthToReturn = 'September';
        }
        else if(month == 10 ){
            MonthToReturn = 'October';
        }
        else if(month == 11 ){
            MonthToReturn = 'November';
        }
        else if(month == 12 ){
            MonthToReturn = 'December';
        }
        }
        return MonthToReturn;
    }
    
    public static string FetchEstimatedDelivery(){
        Datetime now = Datetime.now();
        system.debug('now > ' + now);
        date currentDate = now.date();
        
        //###ONLY FOR TESTING###
        //currentDate = currentDate -3;
        //###ONLY FOR TESTING###
        system.debug('currentDate >'+ currentDate ); 
        
        Datetime currentDate_dt = DateTime.newInstance(currentDate, Time.newInstance(0, 0, 0, 0));
        System.debug('eachdate_dt : ' + currentDate_dt); 
        String currentweekdayofcurrentDate = currentDate_dt.format('EEEE');
        System.debug('currentweekdayofcurrentDate : ' + currentweekdayofcurrentDate);	        
        
        //setup start date & end date
        date startdate = currentDate + 1;        
        date enddate = currentDate + 3;
        
        //bussiness days-- current date is sat- sun
        if(currentweekdayofcurrentDate == 'Saturday' || currentweekdayofcurrentDate == 'Sunday'){
            if(currentweekdayofcurrentDate == 'Saturday'){
                startdate = startdate + 1;
                enddate = enddate + 1;
            }
            
            if(currentweekdayofcurrentDate == 'Sunday'){
                //No changes
                //startdate = startdate + 1;
                //enddate = enddate + 1;
            }
        }        
        
        //bussiness days-- start date is sat- sun
        Datetime startdate_dt = DateTime.newInstance(startdate, Time.newInstance(0, 0, 0, 0));
        System.debug('startdate_dt : ' + startdate_dt); 
        String currentweekdayofstartdateDate = startdate_dt.format('EEEE');
        System.debug('currentweekdayofstartdateDate : ' + currentweekdayofstartdateDate);	        	
        
        //bussiness days--
        if(currentweekdayofstartdateDate == 'Saturday' || currentweekdayofstartdateDate == 'Sunday'){
            if(currentweekdayofstartdateDate == 'Saturday'){
                startdate = startdate + 2;
                enddate = enddate + 2;
            }
            
            if(currentweekdayofstartdateDate == 'Sunday'){
                startdate = startdate + 1;
                enddate = enddate + 1;
            }
        }        
        
        //bussiness days-- end date is sat- sun
        Datetime enddate_dt = DateTime.newInstance(enddate, Time.newInstance(0, 0, 0, 0));
        System.debug('enddate_dt : ' + enddate_dt); 
        String currentweekdayofenddateDate = enddate_dt.format('EEEE');
        System.debug('currentweekdayofenddateDate : ' + currentweekdayofenddateDate);
        
        //bussiness days--
        if(currentweekdayofenddateDate == 'Saturday' || currentweekdayofenddateDate == 'Sunday'){
            if(currentweekdayofenddateDate == 'Saturday'){
                //startdate = startdate + 2;
                enddate = enddate + 2;
            }
            
            if(currentweekdayofenddateDate == 'Sunday'){
                //startdate = startdate + 1;
                enddate = enddate + 1;
            }
        }        
        
        system.debug('FINAL startdate > ' + startdate);
        system.debug('FINAL enddate > ' + enddate);
        
        //get start date & end date month 
        integer StartdateMonth = startdate.month();
        integer enddateMonth = enddate.month();
        
        //fetch out the month name
        string thisStartMOnth = FetchMonth(StartdateMonth);
        string thisEndMOnth = FetchMonth(enddateMonth);
        
        //get start date & end date month 
        integer currentStartDay = startdate.day();
        string thisStartDay = string.valueOf(currentStartDay); 
        integer currentEndDay = enddate.day();
        string thisEndDay = string.valueOf(currentEndDay); 
        
        string finalPickUpDate = thisStartMOnth + ' ' +  thisStartDay + ' - ' + thisEndMOnth + ' ' + thisEndDay;
        return finalPickUpDate;
        
    }
    
    public class dateReturnWrapper{
        public string stockstatus;
        public date startdate;
        public date enddate;
        public date singledate;
    }
    
	public class USHolidayStack{
		public date holidaydate;		
		public boolean isHolidayRecord;
		public boolean isWeekend;
		public string dayofweek;
	}	    
    
	public class canadaHolidayStack{
		public date holidaydate;
		public string provinceIncluded;
		public string proviceExluded;
		public boolean isWeekendrecord;
        public boolean isHolidayRecord; //Used only in case of out of stock
		public string dayofweek;
	}	
            			    
    
}