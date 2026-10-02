package com.erpapay.payinall;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Base64;
import android.view.View;
import com.arksigner.liveauth.tckk.layout.frontside.UITCKKFrontSideReader;
import com.arksigner.liveauth.tckk.layout.frontside.UITCKKFrontSideReaderListener;
import com.arksigner.liveauth.utils.CameraResolution;
import org.jetbrains.annotations.NotNull;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;
import com.erpapay.payinall.AuthManager;
import com.erpapay.payinall.AuthCallback;

 
public class FrontSideActivity extends AppCompatActivity implements UITCKKFrontSideReaderListener {
    private UITCKKFrontSideReader frontSideReader;
 
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_frontside_reader);

        frontSideReader = findViewById(R.id.idCardFrontSideScannerCustomView);
        frontSideReader.showCameraOverlay(true);
        frontSideReader.setCameraPreset(CameraResolution.hd);
        frontSideReader.setTimeoutDurationMs(30000);
        frontSideReader.SetListener(this);
        frontSideReader.start();
    }
 
    @Override
    public void onResume() {
        super.onResume();
        frontSideReader.resume();
    }
 
    @Override
    public void onPause() {
        super.onPause();
        frontSideReader.pause();
    }
 
    @Override

    public void onDestroy() {
        super.onDestroy();
        frontSideReader = null;
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
        frontSideReader.getPhoto().compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
        byte[] imgByteArr = byteArrayOutputStream.toByteArray();
        Map<String, Object> result = new HashMap<String,Object>();
        result.put("image", Base64.encodeToString(imgByteArr, Base64.NO_WRAP));
        AuthManager.getCallback().onSuccess(result);
        finish();
    }
}
