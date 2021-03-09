package xyz.bczl.flutter_scankit;

import com.huawei.hms.ml.scan.HmsScan;

public class ScanKitConstants {

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
}
