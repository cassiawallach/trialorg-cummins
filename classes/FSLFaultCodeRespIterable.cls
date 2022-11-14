global class FSLFaultCodeRespIterable implements iterable<FSLFaultCodeWrapper>{
    global Iterator<FSLFaultCodeWrapper> Iterator(){
        return new FSLFaultCodeIterator();
    }
}