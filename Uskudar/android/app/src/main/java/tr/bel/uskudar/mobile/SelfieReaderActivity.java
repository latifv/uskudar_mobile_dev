package tr.bel.uskudar.mobile;

import android.graphics.Typeface;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.Gravity;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import com.arksigner.liveauth.face.UIFaceCapture;
import com.arksigner.liveauth.face.UIFaceCaptureListener;
import java.util.HashMap;
import java.util.Map;
import tr.bel.uskudar.mobile.AuthManager;
import tr.bel.uskudar.mobile.AuthCallback;


public class SelfieReaderActivity extends AppCompatActivity implements UIFaceCaptureListener {
    private UIFaceCapture uiFaceReader;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_selfie_reader);

        uiFaceReader = findViewById(R.id.selfie_reader);
        uiFaceReader.SetListener(this);
        uiFaceReader.setLivenessMode(1);
        uiFaceReader.setLivenessActionCount(3);
        uiFaceReader.setLivenessAnimAlpha(0.5f);
        uiFaceReader.setLivenessPhotoCount(3);
        uiFaceReader.setLivenessTextSize(TypedValue.COMPLEX_UNIT_SP, 20);
        uiFaceReader.setMinimumEyesOpenProbability(0.6f);
        uiFaceReader.setLivenessModeActionsEyeBlinkEnabled(false);
        uiFaceReader.setTextBackgroundColor(ContextCompat.getColor(this, R.color.transparentColor));
        uiFaceReader.livenessModeAnimShouldBlurCameraView(false);
        uiFaceReader.setLivenessAnimShowDelayMs(0);
        uiFaceReader.setTimeoutDurationMs(60000);
        uiFaceReader.livenessTextStyle(Typeface.NORMAL);
        uiFaceReader.textViewGravity(Gravity.CENTER);
        uiFaceReader.textViewLocation(0);
        uiFaceReader.setInstantStartCapture(true);
        uiFaceReader.setAcceptFacesOnlyInCameraCircle(false);
        uiFaceReader.setCutoutPosition(0.5f);
        uiFaceReader.setLivenessVoiceGuide(false);
        uiFaceReader.start();
    }

    @Override
    public void onPause() {
        super.onPause();
        uiFaceReader.stop();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        uiFaceReader = null;
    }


    @Override
    public void onFaceCaptureTimeout() {
        AuthManager.getCallback().onFail(-2);
        finish();
    }

    @Override
    public void onFaceCaptureFailed(int i) {
        AuthManager.getCallback().onFail(i);
        finish();
    }

    @Override
    public void onFaceCapturedSuccessfully() {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("photos", uiFaceReader.getPhotoSequenceBase64());
        AuthManager.getCallback().onSuccess(result);
        finish();
    }

    @Override
    public void onFaceCaptureNewMessage(String s) {
    }
}
