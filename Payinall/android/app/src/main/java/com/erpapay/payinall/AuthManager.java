package com.erpapay.payinall;

import com.erpapay.payinall.AuthCallback;

public class AuthManager {
    private static AuthCallback callback;
    public static String encodedMrzString = "";
    public static String roomId;
    public static String fullName;
    public static String tckn;

    public static void setCallback(AuthCallback cb) {
        callback = cb;
    }

    public static AuthCallback getCallback() {
        return callback;
    }
} 