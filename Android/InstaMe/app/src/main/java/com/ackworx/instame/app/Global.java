package com.ackworx.instame.app;

/**
 * Created by wuhuijie on 10/8/14.
 */
public class Global
{
    public static final String TAG = "InstaMe";
    public static final String INSTAGRAM_CLIENT_ID  = "509b47de45284016befa747a6ab58956";
    public static final String INSTAGRAM_AUTH_URL   = "https://api.instagram.com/oauth/authorize/";
    public static final String INSTAGRAM_TOKEN_URL  = "https://api.instagram.com/oauth/access_token/";
    public static final String API_URL              = "https://api.instagram.com/v1/";
    public static final String CALLBACK_URL         = "http://inst4me.parseapp.com/";

    public static final String getAuthenticationURL()
    {
        return INSTAGRAM_AUTH_URL + "?client_id=" + INSTAGRAM_CLIENT_ID + "&redirect_uri=" + CALLBACK_URL +
                "&response_type=token";
    }
}
