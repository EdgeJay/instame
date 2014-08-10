package com.ackworx.instame.app;

/**
 * Created by wuhuijie on 10/8/14.
 */
public class Global
{
    public static final String TAG = "InstaMe";
    public static final String INSTAGRAM_CLIENT_ID  = "509b47de45284016befa747a6ab58956";
    public static final String INSTAGRAM_AUTH_URL   = "https://api.instagram.com/oauth/authorize/";
    public static final String API_URL              = "https://api.instagram.com/v1/";
    public static final String CALLBACK_URL         = "http://inst4me.parseapp.com/";
    // User access token
    public static String USER_ACCESS_TOKEN = null;

    public static final String getAuthenticationURL()
    {
        return INSTAGRAM_AUTH_URL + "?client_id=" + INSTAGRAM_CLIENT_ID + "&redirect_uri=" + CALLBACK_URL +
                "&response_type=token";
    }

    public static final String getUserFeedURL()
    {
        if (USER_ACCESS_TOKEN != null)
        {
            return API_URL + "users/self/feed/?client_id=" + INSTAGRAM_CLIENT_ID +
                    "&access_token=" + USER_ACCESS_TOKEN +
                    "&count=28";
        }

        return null;
    }
}
