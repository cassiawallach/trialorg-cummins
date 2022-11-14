global class FSLFailModeRespIterable implements iterable<FSLFailModeWrapper> {
    global Iterator<FSLFailModeWrapper> Iterator() {
        return new FSLFailModeIterators();
    }
}