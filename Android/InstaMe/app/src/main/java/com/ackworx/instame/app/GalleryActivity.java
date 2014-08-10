package com.ackworx.instame.app;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.lucasr.smoothie.AsyncGridView;
import org.lucasr.smoothie.ItemManager;

import java.util.ArrayList;
import java.util.List;

public class GalleryActivity extends ActionBarActivity
{
    public static final int VIEW_FEED_REQUEST = 100;
    public static final int LOGOUT = 200;

    private static final int GALLERY_LOADER = 1;
    private AsyncGridView gridView;
    private GalleryAdapter gridAdapter;
    // Volley
    private RequestQueue queue;
    private JSONObject feedResponse;
    private List<String> thumbnailURLs;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_gallery);

        gridView = (AsyncGridView)findViewById(R.id.grid_view);
        gridAdapter = new GalleryAdapter(this);
        gridView.setAdapter(gridAdapter);

        GalleryLoader loader = new GalleryLoader(this);

        ItemManager.Builder builder = new ItemManager.Builder(loader);
        builder.setPreloadItemsEnabled(true).setPreloadItemsCount(16).setThreadPoolSize(4);
        gridView.setItemManager(builder.build());
    }

    @Override
    protected void onStart()
    {
        super.onStart();

        fetchUserFeed();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.gallery, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_logout)
        {
            logout();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void fetchUserFeed()
    {
        if (queue == null)
        {
            queue = Volley.newRequestQueue(this);
        }

        gridAdapter.clear();
        thumbnailURLs = new ArrayList<String>();

        JsonObjectRequest req = new JsonObjectRequest(Request.Method.GET, Global.getUserFeedURL(), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        feedResponse = response;
                        updateUserFeed();
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                    }
                });

        queue.add(req);
    }

    private void updateUserFeed()
    {
        if (feedResponse != null)
        {
            try
            {
                JSONArray data = feedResponse.getJSONArray("data");
                JSONObject item;
                int i = 0;
                while (i < data.length())
                {
                    item = data.getJSONObject(i);
                    JSONObject images = item.getJSONObject("images");
                    JSONObject thumbnail = images.getJSONObject("thumbnail");

                    String url = thumbnail.getString("url");
                    gridAdapter.add(url);
                    thumbnailURLs.add(url);


                    i++;
                }
            }
            catch (JSONException e)
            {
                e.printStackTrace();
            }
        }
    }

    private void logout()
    {
        Global.USER_ACCESS_TOKEN = null;

        setResult(LOGOUT);
        finish();
    }
}
