global class FSL_MovexServiceTerittoryRespIterable implements iterable<FSL_MovexServiceTerritoryWrapper>{
    global Iterator<FSL_MovexServiceTerritoryWrapper> Iterator(){
        return new FSL_MovexServiceTerritoryIterator();
    }

}