package com.erpapay.payinall;

import android.content.Intent;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.os.Bundle;
import com.bumptech.glide.Glide;
import android.widget.ImageView;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import androidx.appcompat.app.AppCompatActivity;
import com.arksigner.liveauth.tckk.nfc.internal.NFCDataReader;
import com.arksigner.liveauth.tckk.nfc.internal.NFCDataReaderListener;
import com.arksigner.liveauth.tckk.nfc.internal.structs.DatagroupBase;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import java.util.HashMap;
import java.util.Map;
import com.erpapay.payinall.AuthManager;
import com.erpapay.payinall.AuthCallback;

public class NfcReaderActivity extends AppCompatActivity implements NFCDataReaderListener {
    private BottomSheetDialog bottomSheetDialog;
    private Button bottomSheetCancelButton;
    private ProgressBar nfcProgress;
    private NFCDataReader reader;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_nfc_reader);

        bottomSheetDialog = new BottomSheetDialog(this);
        View sheetView = getLayoutInflater().inflate(R.layout.nfc_bottom_sheet, null);
        bottomSheetDialog.setContentView(sheetView);
        bottomSheetCancelButton = bottomSheetDialog.findViewById(R.id.fragment_scan_cancel_button);
        nfcProgress = bottomSheetDialog.findViewById(R.id.progressBar);
        nfcProgress.setProgress(0);
        bottomSheetCancelButton.setOnClickListener(v -> {
            reader.stop();
            bottomSheetDialog.dismiss();
        });
        ImageView imageGif = findViewById(R.id.idcard_intro_imageview);
        Glide.with(this).load(R.drawable.tckk_nfc).into(imageGif);
        reader = new NFCDataReader(this, this, AuthManager.encodedMrzString, null);
        reader.setTimeoutDurationMs(15000);
        reader.setVoiceGuide(false);
        reader.start();
    }

    @Override
    public void onPause() {
        super.onPause();
        if (reader != null) {
            reader.pause();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        reader = null;
    }

    @Override
    public void onResume() {
        super.onResume();
        reader.resume();
    }

    @Override
    public void onDataGroupRead(String datagroupName, int remainingNumberOfDgs, int totalNumberofDgs, int friendlyDataGroupID) {
        nfcProgress.setMax(totalNumberofDgs);
        int currentDGNumber = totalNumberofDgs - remainingNumberOfDgs;
        nfcProgress.setProgress(currentDGNumber);
    }

    @Override
    public void onReadTimeout() {
        AuthManager.getCallback().onFail(-2);
        finish();
    }

    @Override
    public void onReadFailed(int i) {
        AuthManager.getCallback().onFail(i);
        finish();
    }

    @Override
    public void onReadSuccessfully() {
        bottomSheetDialog.dismiss();
        Map<String, Object> result = new HashMap<String, Object>();
        for (DatagroupBase dataGroup : reader.getDataGroup().getDatagroupList()) {
            if (dataGroup.getDataGroupName().equals("EF.COM"))
                result.put("efComBase64", dataGroup.getBase64());
            else if (dataGroup.getDataGroupName().equals("EF.SOD"))
                result.put("efSodBase64", dataGroup.getBase64());
            else
                result.put(dataGroup.getDataGroupName() + "Base64", dataGroup.getBase64());

        }

        result.put("challangeBase64", reader.getInternalAuthChallangeBase64());
        result.put("activeAuthenticationResponseBase64", reader.getInternalAuthResponseBase64());
        AuthManager.getCallback().onSuccess(result);
        finish();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

        Bundle extras = intent.getExtras();

        if (extras != null) {
            if (extras.getInt(getResources().getString(R.string.intent_request_code)) == 48941) {
                Tag tag = intent.getParcelableExtra(NfcAdapter.EXTRA_TAG);
                reader.onNfcTagReceived(tag);
                bottomSheetDialog.show();
            }
        }
    }
}
