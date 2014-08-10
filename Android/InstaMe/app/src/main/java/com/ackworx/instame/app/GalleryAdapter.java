package com.ackworx.instame.app;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;

/**
 * Created by wuhuijie on 11/8/14.
 */
public class GalleryAdapter extends ArrayAdapter<String>
{
    public GalleryAdapter(Context context)
    {
        super(context, 0);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent)
    {
        ViewHolder holder = null;

        if (convertView == null)
        {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.layout_gallery_grid_item, parent, false);

            holder = new ViewHolder();
            holder.image = (ImageView)convertView.findViewById(R.id.image_view);

            convertView.setTag(holder);
        }
        else
        {
            holder = (ViewHolder)convertView.getTag();
        }

        holder.image.setImageDrawable(null);

        return convertView;
    }

    public class ViewHolder
    {
        public ImageView image;
    }
}
