package xyz.icxl.flutter.hms.scan;

import com.huawei.hms.ml.scan.HmsScan;

import java.util.ArrayList;

public class ScanKitUtilities {

    public static final int[] SCAN_TYPES = {
            HmsScan.ALL_SCAN_TYPE,
            HmsScan.QRCODE_SCAN_TYPE,
            HmsScan.AZTEC_SCAN_TYPE,
            HmsScan.DATAMATRIX_SCAN_TYPE,
            HmsScan.PDF417_SCAN_TYPE,
            HmsScan.CODE39_SCAN_TYPE,
            HmsScan.CODE93_SCAN_TYPE,
            HmsScan.CODE128_SCAN_TYPE,
            HmsScan.EAN13_SCAN_TYPE,
            HmsScan.EAN8_SCAN_TYPE,
            HmsScan.ITF14_SCAN_TYPE,
            HmsScan.UPCCODE_A_SCAN_TYPE,
            HmsScan.UPCCODE_E_SCAN_TYPE,
            HmsScan.CODABAR_SCAN_TYPE,
    };

    public static int[] toArray(ArrayList<Integer> scanTypes){
        int len = scanTypes.size() - 1;
        int[] arr = new int[len];
        for (int i = 0; i < len; i++) {
            arr[i] = ScanKitUtilities.SCAN_TYPES[scanTypes.get(i+1)];
        }
        return arr;
    }

    public static int single(ArrayList<Integer> scanTypes){
        if (scanTypes.size() == 1){
            return SCAN_TYPES[scanTypes.get(0)];
        }
        return HmsScan.ALL_SCAN_TYPE;
    }

    public static int first(ArrayList<Integer> scanTypes){
         return SCAN_TYPES[scanTypes.get(0)];
    }
}
