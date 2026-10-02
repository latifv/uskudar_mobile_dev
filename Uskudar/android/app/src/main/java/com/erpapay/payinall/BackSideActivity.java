package com.erpapay.payinall;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Base64;
import androidx.appcompat.app.AppCompatActivity;
import com.arksigner.liveauth.tckk.layout.backside.UITCKKBackSideReader;
import com.arksigner.liveauth.tckk.layout.backside.UITCKKBackSideReaderListener;
import com.arksigner.liveauth.utils.CameraResolution;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;
import com.erpapay.payinall.AuthManager;
import com.erpapay.payinall.AuthCallback;

public class BackSideActivity extends AppCompatActivity implements UITCKKBackSideReaderListener {
 
    private UITCKKBackSideReader backSideReader;
 
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_backside_reader);

        backSideReader = findViewById(R.id.idCardBackSideScannerCustomView);
        backSideReader.showCameraOverlay(true);
        backSideReader.setCameraPreset(CameraResolution.hd);
        backSideReader.setTimeoutDurationMs(30000);
        backSideReader.setListener(this);
        backSideReader.start();
    }
 
    @Override
    public void onResume() {
        super.onResume();
        backSideReader.resume();
    }
 
    @Override
    public void onPause() {
        super.onPause();
        backSideReader.pause();
    }
 
    @Override
    public void onDestroy() {
        super.onDestroy();
        backSideReader = null;
    }
 
    @Override
    public void onReadFailed(int i) {
        AuthManager.getCallback().onFail(i);
        finish();
    }
 
    @Override
    public void onReadTimeout() {
        AuthManager.getCallback().onFail(-2);
        finish();
    }
 
    @Override
    public void onReadSuccessfully() {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        backSideReader.getPhoto().compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
        byte[] imgByteArr = byteArrayOutputStream.toByteArray();
        Map<String, Object> result = new HashMap<String,Object>();
        result.put("image", Base64.encodeToString(imgByteArr, Base64.NO_WRAP));
        result.put("mrzString", AuthManager.encodedMrzString=backSideReader.getEncodedMRZString());
        AuthManager.getCallback().onSuccess(result);
        finish();
    }
}
