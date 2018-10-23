package com.hm.todolist;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class AlarmManagerPlugin {

    private static final String ChannelName = "AlarmManager";
    private static final SimpleDateFormat SDF = new SimpleDateFormat("yyyy/MM/dd hh:mm");
    private static AlarmManager mAlarmManager;

    public static final void register(final Context context, BinaryMessenger messenger) {

        mAlarmManager = (AlarmManager) context.getSystemService(Service.ALARM_SERVICE);

        MethodChannel methodChannel = new MethodChannel(messenger, ChannelName);
        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                switch (methodCall.method) {
                    case "setAlarm":
                        int setId = methodCall.argument("id");
                        String event = methodCall.argument("event");
                        String dateTime = methodCall.argument("time");

                        setAlarm(context, setId, event, dateTime);
                        break;
                    case "cancelAlarm":
                        int cancelId = methodCall.argument("id");

                        cancelAlarm(context,cancelId);
                        break;
                }
            }
        });
    }



    /**
     * @param context
     * @param event    提醒字符串
     * @param dateTime 提醒时间 格式“yyyy/MM/dd hh:mm”
     */
    private static void setAlarm(Context context, int id, String event, String dateTime) {
        Date date = null;
        try {
            date = SDF.parse(dateTime);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (date != null) {
            Intent intent = new Intent();
            intent.setAction("net.tztech.notepad.ALARM");
            intent.putExtra("id", id);
            intent.putExtra("event", event);
            intent.putExtra("time", dateTime.split(" ")[1]);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, id, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT);
            mAlarmManager.set(AlarmManager.RTC_WAKEUP, date.getTime(), pendingIntent);
        }
    }

    /**
     * 取消闹钟提醒
     * @param context
     * @param cancelId
     */
    private static void cancelAlarm(Context context, int cancelId) {
        Intent intent = new Intent();
        intent.setAction("net.tztech.notepad.ALARM");
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, cancelId, intent,
                PendingIntent.FLAG_UPDATE_CURRENT);

        mAlarmManager.cancel(pendingIntent);
    }


}
