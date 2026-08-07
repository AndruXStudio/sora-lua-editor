package com.load.LuaAppX.behavior;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Interpolator;
import androidx.annotation.NonNull;
import androidx.coordinatorlayout.widget.CoordinatorLayout;
import androidx.core.view.ViewCompat;
import androidx.core.view.ViewPropertyAnimatorListener;
import androidx.interpolator.view.animation.FastOutSlowInInterpolator;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

public class FabBehavior extends FloatingActionButton.Behavior {

    private static final Interpolator fastOutSlowInInterpolator = new FastOutSlowInInterpolator();
    private boolean isAnimatingOut = false;
    private boolean isAnimatingIn = false;

    public class AnimationEndListener implements ViewPropertyAnimatorListener {
        AnimationEndListener() {
        }

        public void onAnimationCancel(View view) {
            isAnimatingOut = false;
        }

        public void onAnimationEnd(View view) {
            isAnimatingOut = false;
        }

        public void onAnimationStart(View view) {
            isAnimatingOut = true;
        }
    }

    public class AnimationStartListener implements ViewPropertyAnimatorListener {
        AnimationStartListener() {
        }

        public void onAnimationCancel(View view) {
            isAnimatingIn = false;
        }

        public void onAnimationEnd(View view) {
            isAnimatingIn = false;
        }

        public void onAnimationStart(View view) {
            isAnimatingIn = true;
        }
    }

    public FabBehavior(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    private void animateOut(FloatingActionButton fab) {
        ViewCompat.animate(fab).translationY(fab.getHeight() + getMarginBottom(fab)).setInterpolator(fastOutSlowInInterpolator).withLayer().setListener(new AnimationEndListener()).start();
    }

    private void animateIn(FloatingActionButton fab) {
        ViewCompat.animate(fab).translationY(0.0f).setInterpolator(fastOutSlowInInterpolator).withLayer().setListener(new AnimationStartListener()).start();
    }

    private int getMarginBottom(View view) {
        ViewGroup.LayoutParams layoutParams = view.getLayoutParams();
        if (layoutParams instanceof ViewGroup.MarginLayoutParams) {
            return ((ViewGroup.MarginLayoutParams) layoutParams).bottomMargin;
        }
        return 0;
    }

    public void onNestedScroll(@NonNull CoordinatorLayout coordinatorLayout, @NonNull FloatingActionButton fab, @NonNull View target, int dxConsumed, int dyConsumed, int dxUnconsumed, int dyUnconsumed, int type, @NonNull int[] consumed) {
        super.onNestedScroll(coordinatorLayout, fab, target, dxConsumed, dyConsumed, dxUnconsumed, dyUnconsumed, type, consumed);
        if (dyConsumed > 0 && !isAnimatingOut) {
            animateOut(fab);
        } else if (dyConsumed < 0 && !isAnimatingIn) {
            animateIn(fab);
        }
    }

    public boolean onStartNestedScroll(@NonNull CoordinatorLayout coordinatorLayout, @NonNull FloatingActionButton fab, @NonNull View directTargetChild, @NonNull View target, int nestedScrollAxes, int type) {
        return nestedScrollAxes == ViewCompat.SCROLL_AXIS_VERTICAL;
    }
}