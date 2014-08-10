package com.ackworx.instame.app;

import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.TransitionDrawable;
import android.support.v4.util.LruCache;
import android.view.View;
import android.widget.Adapter;

import org.lucasr.smoothie.SimpleItemLoader;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by wuhuijie on 11/8/14.
 */
public class GalleryLoader extends SimpleItemLoader<String, Bitmap>
{
    private final Context mContext;
    private final LruCache<String, Bitmap> mCache;

    public GalleryLoader(Context context)
    {
        mContext = context;

        int maxSize = (int) (Runtime.getRuntime().maxMemory() * 0.4f);
        mCache = new LruCache<String, Bitmap>(maxSize) {
            @Override
            protected int sizeOf(String url, Bitmap bitmap) {
                return bitmap.getRowBytes() * bitmap.getHeight();
            }
        };
    }

    @Override
    public String getItemParams(Adapter adapter, int position)
    {
        return (String)adapter.getItem(position);
    }

    @Override
    public Bitmap loadItemFromMemory(String urlStr)
    {
        return mCache.get(urlStr);
    }

    @Override
    public Bitmap loadItem(String urlStr)
    {
        if (urlStr != null)
        {
            try
            {
                URL url = new URL(urlStr);
                Bitmap bitmap = BitmapFactory.decodeStream(url.openConnection().getInputStream());
                if (bitmap != null)
                {
                    mCache.put(urlStr, bitmap);
                }

                return bitmap;
            }
            catch (MalformedURLException e)
            {
                e.printStackTrace();
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
        }

        return null;
    }

    @Override
    public void displayItem(View itemView, Bitmap result, boolean fromMemory)
    {
        if (result == null)
        {
            return;
        }

        GalleryAdapter.ViewHolder holder = (GalleryAdapter.ViewHolder)itemView.getTag();
        BitmapDrawable imageDrawable = new BitmapDrawable(itemView.getResources(), result);

        if (fromMemory)
        {
            holder.image.setImageDrawable(imageDrawable);
        }
        else
        {
            BitmapDrawable emptyDrawable = new BitmapDrawable(itemView.getResources());
            TransitionDrawable fadeInDrawable = new TransitionDrawable(new Drawable[]{
                    emptyDrawable, imageDrawable
            });

            holder.image.setImageDrawable(fadeInDrawable);

            fadeInDrawable.startTransition(200);
        }
    }
}
