package xyz.bczl.flutter_scankit;

import java.util.HashMap;

public class ScanResult {
    private String originalValue;
    private int scanType;

    public ScanResult(String originalValue, int scanType) {
        this.originalValue = originalValue;
        this.scanType = scanType;
    }

    public String getOriginalValue() {
        return originalValue;
    }

    public int getScanType() {
        return scanType;
    }

    HashMap<String,Object> toMap(){
        HashMap<String,Object> map = new HashMap<>();
        map.put("originalValue",originalValue);
        map.put("scanType",scanType);
        return map;
    }
}
