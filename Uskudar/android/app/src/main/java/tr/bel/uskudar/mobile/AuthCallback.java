package tr.bel.uskudar.mobile;

import java.util.Map;
public interface AuthCallback {
    void onSuccess(Map<String, Object> value);
    void onFail(int value);
}