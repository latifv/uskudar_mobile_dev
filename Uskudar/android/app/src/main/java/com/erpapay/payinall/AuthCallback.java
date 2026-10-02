package com.erpapay.payinall;

import java.util.Map;
public interface AuthCallback {
    void onSuccess(Map<String, Object> value);
    void onFail(int value);
}