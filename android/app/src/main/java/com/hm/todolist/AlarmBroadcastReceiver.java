package com.hm.todolist;

import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class AlarmBroadcastReceiver extends BroadcastReceiver {

    private NotificationManager mNotifyManager;

    @Override
    public void onReceive(Context context, Intent intent) {

        if (mNotifyManager == null) {
            mNotifyManager = (NotificationManager) context.getSystemService(Context
                    .NOTIFICATION_SERVICE);
        }

        int id = intent.getIntExtra("id", -1);
        String event = intent.getStringExtra("event");
        String time = intent.getStringExtra("time");

        if (TextUtils.isEmpty(time) || id == -1) {
            return;
        }

        //发送通知
        sendNotification(context, id, event, time);
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    private void sendNotification(Context context, int id, String event, String time) {

        Notification notification = new Notification.Builder(context.getApplicationContext())
                .setContentTitle("您在 " + time + " 有事情要做哦")
                .setContentText(event)
                .setSmallIcon(android.R.mipmap.sym_def_app_icon)
                .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), android.R
                        .mipmap.sym_def_app_icon))
                .setContentIntent(null)
                .setAutoCancel(true)
                // 获取Android多媒体库内的铃声
                // builder.setSound(Uri.withAppendedPath(MediaStore.Audio.Media
                // .INTERNAL_CONTENT_URI, "0"));
                .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))//
                .setVibrate(new long[]{100, 200, 300})
                .setDefaults(Notification.DEFAULT_ALL).build();

        mNotifyManager.notify(id, notification);
    }
}
