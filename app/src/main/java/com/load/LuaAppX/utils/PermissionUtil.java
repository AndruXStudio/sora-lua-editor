package com.load.LuaAppX.utils;

import android.Manifest;
import android.content.pm.PackageManager;
import androidx.core.app.ActivityCompat;
import androidx.appcompat.app.AppCompatActivity;
import java.util.ArrayList;
import android.app.Activity;


public class PermissionUtil {
    private static final int REQUEST_CODE = 0;
    private static Activity activity;

    public static void setActivity(Activity theActivity) {
        activity = theActivity;
    }

    public static boolean checkPermission(String permission) {
        return ActivityCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_GRANTED;
    }

    public static boolean check(String[] permissions) {
        for (String permission : permissions) {
            boolean granted = checkPermission(permission);
            if (!granted) {
                return false;
            }
        }
        return true;
    }

    public static void request(String[] permissions) {
        ActivityCompat.requestPermissions(activity, permissions, REQUEST_CODE);
    }

    public static void requestAll() {
        ArrayList<String> requestedPermissions = new ArrayList<>();
        String[] ungrantedPermissions;
        if (activity != null) {
            try {
                String packageName = activity.getPackageName();
                PackageManager packageManager = activity.getPackageManager();
                String[] packagePermissions = packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS).requestedPermissions;
                if (packagePermissions != null) {
                    for (String permission : packagePermissions) {
                        if (ActivityCompat.checkSelfPermission(activity, permission) != PackageManager.PERMISSION_GRANTED) {
                            requestedPermissions.add(permission);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        ungrantedPermissions = requestedPermissions.toArray(new String[requestedPermissions.size()]);
        ActivityCompat.requestPermissions(activity, ungrantedPermissions, REQUEST_CODE);
    }

}    