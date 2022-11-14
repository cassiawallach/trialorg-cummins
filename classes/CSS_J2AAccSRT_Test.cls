@isTest
public class CSS_J2AAccSRT_Test {		
	static testMethod void testParse() {
		String json = '{'+
		'   \"DataArea\":    {'+
		'      \"CaseResponse\":       ['+
		'                  {'+
		'            \"SRTTitle\": \"Air Cleaner Assembly (Including Bracket) - Remove and Install, Each\",'+
		'            \"SRTDetails\": \"10-117\",'+
		'            \"SRTID\": 116840'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Air Conditioner Condenser - Move for Access\",'+
		'            \"SRTDetails\": \"17-102\",'+
		'            \"SRTID\": 19807'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Air Conditioner System - Evacuate and Recharge\",'+
		'            \"SRTDetails\": \"17-103\",'+
		'            \"SRTID\": 19808'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Air Governor - Remove and Install\",'+
		'            \"SRTDetails\": \"12-104\",'+
		'            \"SRTID\": 19769'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Belly Pan - Remove and Install\",'+
		'            \"SRTDetails\": \"17-105\",'+
		'            \"SRTID\": 19810'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Bull Bar - Remove and Install\",'+
		'            \"SRTDetails\": \"17-106\",'+
		'            \"SRTID\": 19811'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Bull Bar-Tilt Down (with quick release pins or locking bolts)- Remove and Install\",'+
		'            \"SRTDetails\": \"17-100\",'+
		'            \"SRTID\": 111590'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Bumper - Remove and Install\",'+
		'            \"SRTDetails\": \"17-107\",'+
		'            \"SRTID\": 19812'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Cab Guard, Headache Rack - Remove and Install\",'+
		'            \"SRTDetails\": \"17-109\",'+
		'            \"SRTID\": 19814'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Cab Heater Shutoff Valve -  Remove and Install, Each\",'+
		'            \"SRTDetails\": \"08-033\",'+
		'            \"SRTID\": 120142'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Charge Air Cooler - Remove and Install (Part of Another Repair)\",'+
		'            \"SRTDetails\": \"10-146\",'+
		'            \"SRTID\": 19743'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Charge Air Pipe - Remove and Install, Each\",'+
		'            \"SRTDetails\": \"10-144\",'+
		'            \"SRTID\": 19741'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Cold Start Aid and Bracket - Remove and Install\",'+
		'            \"SRTDetails\": \"17-111\",'+
		'            \"SRTID\": 19816'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Crossmember, Front Cab Support - Remove and Install\",'+
		'            \"SRTDetails\": \"17-112\",'+
		'            \"SRTID\": 19817'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Crossmember, Rear Cab Support - Remove and Install\",'+
		'            \"SRTDetails\": \"17-114\",'+
		'            \"SRTID\": 19819'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Crossmember, Under Oil Pan - Remove and Install\",'+
		'            \"SRTDetails\": \"17-115\",'+
		'            \"SRTID\": 19820'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Crossmember, Under Transmission - Remove and Install\",'+
		'            \"SRTDetails\": \"17-116\",'+
		'            \"SRTID\": 19821'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"De-energize, Hybrid Electric System\",'+
		'            \"SRTDetails\": \"17-400\",'+
		'            \"SRTID\": 120301'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Deck Plate, Between Frame Rails - Remove and Install\",'+
		'            \"SRTDetails\": \"17-117\",'+
		'            \"SRTID\": 19822'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Disabled Vehicle - Move Into Shop (Automotive Only)\",'+
		'            \"SRTDetails\": \"17-004\",'+
		'            \"SRTID\": 73353'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Driveline - Reconnect (Automotive Only)\",'+
		'            \"SRTDetails\": \"17-163\",'+
		'            \"SRTID\": 19863'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Engine Cover, In-cab, without Quick Release Clamps - Remove and Install\",'+
		'            \"SRTDetails\": \"17-119\",'+
		'            \"SRTID\": 19824'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Fan Guard, Shroud Circular Type - Remove and Install, Each\",'+
		'            \"SRTDetails\": \"08-136\",'+
		'            \"SRTID\": 19707'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Fender - Remove and Install, Each\",'+
		'            \"SRTDetails\": \"17-123\",'+
		'            \"SRTID\": 19828'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Fender Extension - Remove and Install (Automotive Application)\",'+
		'            \"SRTDetails\": \"17-179\",'+
		'            \"SRTID\": 103186'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Floorboard - Remove and Install (Automotive, Bus, and Recreational Vehicle Applications only)\",'+
		'            \"SRTDetails\": \"17-124\",'+
		'            \"SRTID\": 19829'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Grille - Remove and Install\",'+
		'            \"SRTDetails\": \"17-125\",'+
		'            \"SRTID\": 19830'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Hood, Tilt - Remove and Install\",'+
		'            \"SRTDetails\": \"17-128\",'+
		'            \"SRTID\": 19833'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Hydraulic Oil Cooler or Transmission Oil Cooler - Remove and Install\",'+
		'            \"SRTDetails\": \"17-174\",'+
		'            \"SRTID\": 125898'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Inner Fender - Remove and Install (Automotive Applications)\",'+
		'            \"SRTDetails\": \"17-167\",'+
		'            \"SRTID\": 19866'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Mobile Vehicle/Equipment Lift System- Set Up\",'+
		'            \"SRTDetails\": \"17-154\",'+
		'            \"SRTID\": 112123'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Noise Panel, Front - Remove and Install\",'+
		'            \"SRTDetails\": \"17-132\",'+
		'            \"SRTID\": 19837'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Noise Panel, Oil Pan - Remove and Install\",'+
		'            \"SRTDetails\": \"17-133\",'+
		'            \"SRTID\": 19838'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Noise Panel, Side - Remove and Install\",'+
		'            \"SRTDetails\": \"17-134\",'+
		'            \"SRTID\": 19839'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"PTO - Transmission/Reservoir Drain and Fill\",'+
		'            \"SRTDetails\": \"17-165\",'+
		'            \"SRTID\": 19864'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Passenger Seat, without Quick Release Clamps - Remove and Install\",'+
		'            \"SRTDetails\": \"17-136\",'+
		'            \"SRTID\": 19841'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Power Steering Pump - Move for Access\",'+
		'            \"SRTDetails\": \"17-138\",'+
		'            \"SRTID\": 19843'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Power Steering Reservoir - Move for Access\",'+
		'            \"SRTDetails\": \"17-162\",'+
		'            \"SRTID\": 19862'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Power Takeoff Shaft, Front - Disconnect and Connect\",'+
		'            \"SRTDetails\": \"17-137\",'+
		'            \"SRTID\": 19842'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Radiator - Remove and Install (Part of Another Repair)\",'+
		'            \"SRTDetails\": \"17-140\",'+
		'            \"SRTID\": 19845'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Radiator Brace - Remove and Install, Each\",'+
		'            \"SRTDetails\": \"17-161\",'+
		'            \"SRTID\": 19861'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Radiator Shroud - Move for Access\",'+
		'            \"SRTDetails\": \"17-143\",'+
		'            \"SRTID\": 19848'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Radiator Shutter Assembly - Remove and Install\",'+
		'            \"SRTDetails\": \"17-144\",'+
		'            \"SRTID\": 19849'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Radiator Shutter Cylinder - Remove and Install\",'+
		'            \"SRTDetails\": \"17-145\",'+
		'            \"SRTID\": 19850'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Refrigerant Compressor and Bracket - Remove and Install\",'+
		'            \"SRTDetails\": \"17-101\",'+
		'            \"SRTID\": 19806'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Shift Tower or Control Island - Remove and Install\",'+
		'            \"SRTDetails\": \"17-147\",'+
		'            \"SRTID\": 19852'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Skid Plate, Under Oil Pan - Remove and Install\",'+
		'            \"SRTDetails\": \"17-148\",'+
		'            \"SRTID\": 19853'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Steering Shaft - Disconnect and Connect\",'+
		'            \"SRTDetails\": \"17-149\",'+
		'            \"SRTID\": 19854'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Transmission, Automatic or Torque Converter - Remove and Install\",'+
		'            \"SRTDetails\": \"17-150\",'+
		'            \"SRTID\": 19855'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Transmission, Manual - Remove and Install\",'+
		'            \"SRTDetails\": \"17-151\",'+
		'            \"SRTID\": 19856'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Vehicle Fairing - Remove and Install\",'+
		'            \"SRTDetails\": \"17-185\",'+
		'            \"SRTID\": 109690'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Vehicle Steps - Remove and Install\",'+
		'            \"SRTDetails\": \"17-184\",'+
		'            \"SRTID\": 109689'+
		'         },'+
		'         {\"SRTTitle\": \"DUMMY\"},'+
		'         {\"SRTTitle\": \"DUMMY\"}'+
		'      ],'+
		'      \"ResponseMessage\": \"\"'+
		'   },'+
		'   \"Header\":    {'+
		'      \"ReturnCodeDescription\": \"\",'+
		'      \"Status\": \"Success\"'+
		'   }'+
		'}';
		CSS_J2AAccess_SRT obj = CSS_J2AAccess_SRT.parse(json);
		System.assert(obj != null);
	}
}