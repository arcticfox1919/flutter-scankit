package xyz.bczl.flutter_scankit;

import com.huawei.hms.ml.scan.HmsScan;

import java.util.ArrayList;

public class ScanKitUtilities {
    static final int ALL = (1 << 13) - 1;

    public static final int[] SCAN_TYPES = {
            HmsScan.AZTEC_SCAN_TYPE,
            HmsScan.CODABAR_SCAN_TYPE,
            HmsScan.CODE39_SCAN_TYPE,
            HmsScan.CODE93_SCAN_TYPE,
            HmsScan.CODE128_SCAN_TYPE,
            HmsScan.DATAMATRIX_SCAN_TYPE,
            HmsScan.EAN8_SCAN_TYPE,
            HmsScan.EAN13_SCAN_TYPE,
            HmsScan.ITF14_SCAN_TYPE,
            HmsScan.PDF417_SCAN_TYPE,
            HmsScan.QRCODE_SCAN_TYPE,
            HmsScan.UPCCODE_A_SCAN_TYPE,
            HmsScan.UPCCODE_E_SCAN_TYPE,
    };

    public static int[] getArrayFromFlags(int flags){
        if (flags == ALL){
            return new int[]{HmsScan.ALL_SCAN_TYPE};
        }
        ArrayList<Integer> types = new ArrayList<>();
        for (int i = 0; i < Integer.SIZE; i++) {
            int mask = 1 << i;
            if ((flags & mask) != 0) {
                types.add(SCAN_TYPES[i]);
            }
        }
        return types.stream().mapToInt(Integer::intValue).toArray();
    }

    public static int getTypeFromFlags(int flags){
        if (flags == ALL){
            return HmsScan.ALL_SCAN_TYPE;
        }
        for (int i = 0; i < Integer.SIZE; i++) {
            int mask = 1 << i;
            if ((flags & mask) != 0) {
                return SCAN_TYPES[i];
            }
        }
        return HmsScan.ALL_SCAN_TYPE;
    }

    public static int scanTypeToFlags(int type){
        if(type == HmsScan.ALL_SCAN_TYPE){
            return ALL;
        }

        for (int i = 0; i < SCAN_TYPES.length; i++) {
            if(SCAN_TYPES[i] == type){
                int mask = 1 << i;
                return mask;
            }
        }
        return ALL;
    }
}
