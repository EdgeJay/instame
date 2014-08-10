package com.ackworx.instame.app;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.WebView;
import android.webkit.WebViewClient;


public class MainActivity extends ActionBarActivity
{
    private WebView loginWebView;
    private CookieSyncManager cookieSyncManager;
    private CookieManager cookieManager;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        cookieSyncManager = CookieSyncManager.createInstance(this);
        cookieManager = CookieManager.getInstance();

        loginWebView = (WebView)findViewById(R.id.login_web_view);
        loginWebView.getSettings().setJavaScriptEnabled(true);
        loginWebView.setWebViewClient(new WebViewClient() {

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {

                if (url.startsWith(Global.CALLBACK_URL)) {

                    // Extract access token
                    String parts[] = url.split("=");
                    Global.USER_ACCESS_TOKEN = parts[1];
                    Log.d(Global.TAG, "Got access token: " + Global.USER_ACCESS_TOKEN);

                    gotoFeedView();

                    return true;
                }

                return false;
            }
        });
    }

    @Override
    protected void onStart()
    {
        super.onStart();

        loginWebView.loadUrl(Global.getAuthenticationURL());
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings)
        {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        if (requestCode == GalleryActivity.VIEW_FEED_REQUEST)
        {
            if (resultCode == GalleryActivity.LOGOUT)
            {
                cookieManager.removeAllCookie();
                loginWebView.loadUrl(Global.getAuthenticationURL());
            }
        }
    }

    private void gotoFeedView()
    {
        Intent intent = new Intent(this, GalleryActivity.class);
        startActivityForResult(intent, GalleryActivity.VIEW_FEED_REQUEST);
    }
}
