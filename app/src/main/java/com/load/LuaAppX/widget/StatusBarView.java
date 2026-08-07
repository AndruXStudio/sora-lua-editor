package com.load.LuaAppX.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;

public class StatusBarView extends View {

    private int statusBarHeight;

    public StatusBarView(Context context) {
        super(context);
        init(context);
    }

    public StatusBarView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public StatusBarView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context);
    }

    private void init(Context context) {
        int result = 0;
        int resourceId = context.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = context.getResources().getDimensionPixelSize(resourceId);
        }
        statusBarHeight = result;
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        setMeasuredDimension(widthMeasureSpec, statusBarHeight);
    }
}