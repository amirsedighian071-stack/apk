package com.saminsoftware.remotemediastar.theme;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.RippleDrawable;
import android.graphics.drawable.StateListDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.ScaleAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

/**
 * ThemeManager - visual engine for MediaStar Remote.
 *
 *  * 7 colour themes, chosen from an in-app gallery and persisted in SharedPreferences
 *  * animated page transitions (fade / slide / zoom / flip) for every page switch
 *  * the "developer" (about) page with the Instagram / Telegram / GitHub bridges
 *
 * NOTE: this class intentionally references the original B4A package name of the
 * *code* (com.saminsoftware.remotemediastar) while the *application id* of the APK
 * is com.developeramira.remotemediastar, so the app can be installed next to the
 * original build.
 */
public final class ThemeManager {

    public static final String PREFS = "mediastar_theme_prefs";
    public static final String KEY_THEME = "theme_id";

    public static final String[] THEME_IDS = {
            "light", "dark", "neon", "classic", "ocean", "sunset", "forest"
    };

    /** Persian theme names, shown in the picker. */
    public static final String[] THEME_NAMES = {
            "\u062A\u0645 \u0631\u0648\u0634\u0646 \u2013 \u0644\u0648\u062A\u0648\u0633",
            "\u062A\u0645 \u062A\u0627\u0631\u06CC\u06A9 \u0645\u062F\u0631\u0646",
            "\u062A\u0645 \u0646\u0626\u0648\u0646\u06CC",
            "\u062A\u0645 \u06A9\u0644\u0627\u0633\u06CC\u06A9 \u0686\u0648\u0628\u06CC",
            "\u062A\u0645 \u0627\u0642\u06CC\u0627\u0646\u0648\u0633\u06CC",
            "\u062A\u0645 \u063A\u0631\u0648\u0628",
            "\u062A\u0645 \u062C\u0646\u06AF\u0644\u06CC \u2013 \u0632\u0645\u0631\u062F"
    };

    /** Short Persian description shown under every theme name. */
    public static final String[] THEME_TAGS = {
            "\u0631\u0648\u0634\u0646\u060C \u06AF\u0631\u0645 \u0648 \u062E\u0648\u0627\u0646\u0627",
            "\u0634\u0628\u06AF\u0631\u062F\u06CC\u060C \u0645\u062F\u0631\u0646 \u0648 \u0686\u0634\u0645\u200C\u0646\u0648\u0627\u0632",
            "\u062F\u0631\u062E\u0634\u0627\u0646 \u0628\u0627 \u0631\u0646\u06AF\u200C\u0647\u0627\u06CC \u0646\u0626\u0648\u0646\u06CC",
            "\u06AF\u0631\u0645\u060C \u0686\u0648\u0628\u06CC \u0648 \u0637\u0644\u0627\u06CC\u06CC",
            "\u0622\u0631\u0627\u0645 \u0628\u0627 \u0622\u0628\u06CC \u0627\u0642\u06CC\u0627\u0646\u0648\u0633",
            "\u067E\u0631\u0627\u0646\u0631\u0698\u06CC \u0628\u0627 \u0646\u0627\u0631\u0646\u062C\u06CC \u0648 \u0627\u0631\u063A\u0648\u0627\u0646\u06CC",
            "\u0633\u0628\u0632\u060C \u062A\u0627\u0632\u0647 \u0648 \u0637\u0628\u06CC\u0639\u06CC"
    };

    /** Palette slot indexes. */
    public static final int BG_TOP = 0;
    public static final int BG_MID = 1;
    public static final int BG_BOTTOM = 2;
    public static final int PANEL_TOP = 3;
    public static final int PANEL_BOTTOM = 4;
    public static final int SURFACE = 5;
    public static final int SURFACE_ALT = 6;
    public static final int CARD = 7;
    public static final int CARD_BORDER = 8;
    public static final int ACCENT = 9;
    public static final int ACCENT_ALT = 10;
    public static final int ACCENT_SOFT = 11;
    public static final int TEXT_ON_BG = 12;
    public static final int TEXT_MUTED = 13;
    public static final int TEXT_ON_ACCENT = 14;
    public static final int DANGER = 15;
    public static final int SUCCESS = 16;
    public static final int SLOT_COUNT = 17;

    private static final int[][] PALETTES = {
            // 0 - light (Lotus)
            {0xFDFAF2, 0xF7F1E3, 0xEFE4CC, 0xFFFFFF, 0xF5EFE2, 0xFFFBF3, 0xF3EAD8,
                    0xFFFDF8, 0xE3D5B4, 0xC9A227, 0x8C6D1F, 0xF2E3BF, 0x3A3020, 0x7A6A50,
                    0xFFFDF8, 0xD6453F, 0x2E8B57},
            // 1 - dark (modern night)
            {0x101019, 0x151F2E, 0x0A0E16, 0x1E2A3B, 0x141C28, 0x1A2230, 0x223040,
                    0x1C2636, 0x2E3E52, 0xE7C46B, 0xFFD98A, 0x333F52, 0xF1F5FB, 0x9AA8BA,
                    0x141C28, 0xE05A5A, 0x59C98E},
            // 2 - neon
            {0x0B0614, 0x14092A, 0x08040F, 0x241044, 0x150A26, 0x1D0E36, 0x2A1548,
                    0x1F1038, 0x43267A, 0x22D3EE, 0xFF3DCB, 0x2E1A52, 0xF5ECFF, 0xB69FD6,
                    0x0A0410, 0xFF5C8A, 0x5BFFC8},
            // 3 - classic wood + gold
            {0x2A1C12, 0x3A2617, 0x1E1409, 0x4A3320, 0x33220F, 0x3D2A18, 0x4F3823,
                    0x43301C, 0x6B4C2A, 0xD4AF37, 0xE8C766, 0x5A3F22, 0xF7EBD3, 0xC3A882,
                    0x2A1C12, 0xB3462F, 0x6FBF73},
            // 4 - ocean
            {0x061826, 0x0B2A3F, 0x04121C, 0x0E3550, 0x092538, 0x0C2C43, 0x114058,
                    0x0E3348, 0x1A5470, 0x3FC1C9, 0x2A9DB5, 0x123F58, 0xE8F7FA, 0x8FB6C4,
                    0x04121C, 0xE2545A, 0x4FD1A5},
            // 5 - sunset
            {0x2B0F22, 0x4A1633, 0x1A0814, 0x5C2140, 0x38102A, 0x45192F, 0x5A2542,
                    0x4B1D36, 0x74314F, 0xFF8A3D, 0xFFB74D, 0x6A2A47, 0xFFF3E9, 0xD9A28F,
                    0x2B0F22, 0xE04B5C, 0x69D08A},
            // 6 - forest
            {0x0A1F16, 0x123024, 0x061510, 0x1A3D2C, 0x0F281D, 0x163528, 0x204534,
                    0x19392A, 0x2C5C44, 0x5BD98B, 0xA3E635, 0x23503C, 0xECF7F0, 0x9BBCA9,
                    0x0A1F16, 0xE06C5A, 0x7BE495},
    };

    private static int[] current = PALETTES[0];
    private static String currentId = "light";
    private static boolean loaded = false;
    private static final Handler MAIN = new Handler(Looper.getMainLooper());

    private ThemeManager() {
    }

    private static Activity activity() {
        try {
            return com.saminsoftware.remotemediastar.main.mostCurrent;
        } catch (Throwable t) {
            return null;
        }
    }

    private static Context ctx() {
        Activity a = activity();
        if (a != null) {
            return a;
        }
        try {
            return com.saminsoftware.remotemediastar.main.mostCurrent;
        } catch (Throwable t) {
            return null;
        }
    }

    private static SharedPreferences prefs() {
        Context c = ctx();
        if (c == null) {
            return null;
        }
        try {
            return c.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
        } catch (Throwable t) {
            return null;
        }
    }

    // ------------------------------------------------------------------
    // Persistence
    // ------------------------------------------------------------------

    /** Reads the stored theme once (falls back to the legacy theme.txt flag). */
    public static void loadPrefs() {
        if (loaded) {
            return;
        }
        loaded = true;
        int idx = -1;
        SharedPreferences p = prefs();
        if (p != null) {
            idx = indexOf(p.getString(KEY_THEME, null));
        }
        if (idx < 0) {
            idx = 0;
            try {
                Context c = ctx();
                if (c != null) {
                    java.io.File f = new java.io.File(c.getFilesDir(), "theme.txt");
                    if (f.exists()) {
                        java.io.BufferedReader r = new java.io.BufferedReader(
                                new java.io.FileReader(f));
                        String line = r.readLine();
                        r.close();
                        int legacy = indexOf(line);
                        if (legacy >= 0) {
                            idx = legacy;
                        }
                    }
                }
            } catch (Throwable ignored) {
            }
        }
        currentId = THEME_IDS[idx];
        current = PALETTES[idx];
    }

    public static String getTheme() {
        loadPrefs();
        return currentId;
    }

    public static void setTheme(String id) {
        loadPrefs();
        int idx = indexOf(id);
        if (idx < 0) {
            idx = 0;
        }
        currentId = THEME_IDS[idx];
        current = PALETTES[idx];
        SharedPreferences p = prefs();
        if (p != null) {
            try {
                p.edit().putString(KEY_THEME, currentId).apply();
            } catch (Throwable ignored) {
            }
        }
    }

    /** Persists one of the 7 themes by index (0..6). */
    public static void setThemeIndex(int index) {
        setTheme(THEME_IDS[safe(index)]);
    }

    /** Keeps the old light/dark flag in sync so the original code keeps working. */
    public static void syncLegacyFlag() {
        try {
            com.saminsoftware.remotemediastar.main._vv1 = isDark();
            Context c = ctx();
            if (c != null) {
                java.io.FileWriter w = new java.io.FileWriter(
                        new java.io.File(c.getFilesDir(), "theme.txt"));
                w.write(isDark() ? "dark" : "light");
                w.close();
            }
        } catch (Throwable ignored) {
        }
    }

    public static int indexOf(String id) {
        if (id == null) {
            return -1;
        }
        String s = id.trim().toLowerCase();
        for (int i = 0; i < THEME_IDS.length; i++) {
            if (THEME_IDS[i].equals(s)) {
                return i;
            }
        }
        if (s.length() > 0 && "dark".startsWith(s)) {
            return 1;
        }
        if (s.length() > 0 && "light".startsWith(s)) {
            return 0;
        }
        return -1;
    }

    public static int count() {
        return THEME_IDS.length;
    }

    public static String themeId(int index) {
        return THEME_IDS[safe(index)];
    }

    public static String themeName(int index) {
        return THEME_NAMES[safe(index)];
    }

    public static String themeTag(int index) {
        return THEME_TAGS[safe(index)];
    }

    private static int safe(int index) {
        if (index < 0 || index >= THEME_IDS.length) {
            return 0;
        }
        return index;
    }

    public static boolean isDark() {
        loadPrefs();
        return !"light".equals(currentId);
    }

    // ------------------------------------------------------------------
    // Palette
    // ------------------------------------------------------------------

    public static int color(int slot) {
        loadPrefs();
        if (slot < 0 || slot >= SLOT_COUNT) {
            return 0xFF000000;
        }
        return current[slot];
    }

    public static int color() {
        return color(ACCENT);
    }

    public static int accentColor() {
        return color(ACCENT);
    }

    public static int textColor() {
        return color(TEXT_ON_BG);
    }

    public static int gradientTop() {
        return color(BG_TOP);
    }

    public static int gradientBottom() {
        return color(BG_BOTTOM);
    }

    public static int pageBackground() {
        return color(BG_TOP);
    }

    public static int panelTop() {
        return color(PANEL_TOP);
    }

    public static int panelBottom() {
        return color(PANEL_BOTTOM);
    }

    /** Background colour for a settings-panel button (key = B4A view name). */
    public static int panelButtonColor(String key) {
        loadPrefs();
        if (key == null) {
            return current[CARD];
        }
        String k = key.toLowerCase();
        if (k.contains("close") || k.contains("back")) {
            return blend(current[BG_MID], current[DANGER], 0.20f);
        }
        if (k.contains("theme")) {
            return blend(current[BG_MID], current[ACCENT], 0.26f);
        }
        if (k.contains("developer") || k.contains("about") || k.contains("dev")) {
            return blend(current[BG_MID], current[ACCENT_ALT], 0.24f);
        }
        return current[CARD];
    }

    public static int blend(int from, int to, float ratio) {
        float r = Color.red(from) * (1f - ratio) + Color.red(to) * ratio;
        float g = Color.green(from) * (1f - ratio) + Color.green(to) * ratio;
        float b = Color.blue(from) * (1f - ratio) + Color.blue(to) * ratio;
        return Color.rgb(clamp((int) r), clamp((int) g), clamp((int) b));
    }

    private static int clamp(int v) {
        return v < 0 ? 0 : (v > 255 ? 255 : v);
    }

    public static int alpha(int color, int a) {
        return (a << 24) | (color & 0x00FFFFFF);
    }

    public static int dp(Context c, int value) {
        if (c == null) {
            return value;
        }
        try {
            return (int) (value * c.getResources().getDisplayMetrics().density + 0.5f);
        } catch (Throwable t) {
            return value;
        }
    }

    // ------------------------------------------------------------------
    // Drawables
    // ------------------------------------------------------------------

    public static GradientDrawable vertical(int top, int bottom) {
        GradientDrawable g = new GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM,
                new int[]{top, bottom});
        g.setDither(true);
        return g;
    }

    public static GradientDrawable pageGradient() {
        return vertical(color(BG_TOP), color(BG_BOTTOM));
    }

    public static GradientDrawable panelGradient() {
        return vertical(color(PANEL_TOP), color(PANEL_BOTTOM));
    }

    public static GradientDrawable card(int fill, int stroke) {
        GradientDrawable g = new GradientDrawable();
        g.setColor(fill);
        g.setCornerRadius(dp(ctx(), 16));
        if (stroke != 0) {
            g.setStroke(Math.max(1, dp(ctx(), 1)), stroke);
        }
        return g;
    }

    public static GradientDrawable button(String key) {
        int base = panelButtonColor(key);
        GradientDrawable g = new GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM,
                new int[]{blend(base, Color.WHITE, 0.06f), base});
        g.setCornerRadius(dp(ctx(), 12));
        g.setStroke(Math.max(1, dp(ctx(), 1)), alpha(color(ACCENT), 0x66));
        return g;
    }

    public static Drawable buttonState(String key) {
        try {
            GradientDrawable normal = button(key);
            int base = panelButtonColor(key);
            GradientDrawable pressed = new GradientDrawable(
                    GradientDrawable.Orientation.TOP_BOTTOM,
                    new int[]{blend(base, color(ACCENT), 0.38f),
                            blend(base, color(ACCENT), 0.20f)});
            pressed.setCornerRadius(dp(ctx(), 12));
            pressed.setStroke(Math.max(1, dp(ctx(), 1)), color(ACCENT));
            if (Build.VERSION.SDK_INT >= 21) {
                return new RippleDrawable(ColorStateList.valueOf(alpha(color(ACCENT), 0x55)),
                        normal, null);
            }
            StateListDrawable sl = new StateListDrawable();
            sl.addState(new int[]{android.R.attr.state_pressed}, pressed);
            sl.addState(new int[]{}, normal);
            return sl;
        } catch (Throwable t) {
            return button(key);
        }
    }

    // ------------------------------------------------------------------
    // Live re-theming
    // ------------------------------------------------------------------

    public static void applyToWindow(Activity a) {
        try {
            Window w = a.getWindow();
            if (w == null) {
                return;
            }
            w.setBackgroundDrawable(pageGradient());
            if (Build.VERSION.SDK_INT >= 21) {
                w.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
                w.setStatusBarColor(color(BG_TOP));
                w.setNavigationBarColor(color(BG_BOTTOM));
                View decor = w.getDecorView();
                int ui = decor.getSystemUiVisibility();
                if (isDark()) {
                    ui &= ~View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
                } else {
                    ui |= View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
                }
                decor.setSystemUiVisibility(ui);
            }
        } catch (Throwable ignored) {
        }
    }

    /**
     * Applies the picked theme everywhere: removes the picker, recolours the window
     * chrome and rebuilds the remote screen with the new palette.
     */
    public static void applyThemeLive() {
        try {
            remove(themeOverlay);
            themeOverlay = null;
            Activity a = activity();
            if (a != null) {
                applyToWindow(a);
            }
            com.saminsoftware.remotemediastar.main._vv5();
            View root = a == null ? null : a.findViewById(android.R.id.content);
            animateHero(root);
        } catch (Throwable t) {
            toast("\u062A\u0645 \u0627\u0639\u0645\u0627\u0644 \u0634\u062F");
        }
    }

    /** Animated exit for the settings overlay (fade + slide, then detach). */
    public static void hideSettingsPanel() {
        try {
            final com.saminsoftware.remotemediastar.main a =
                    com.saminsoftware.remotemediastar.main.mostCurrent;
            if (a == null) {
                return;
            }
            final anywheresoftware.b4a.objects.PanelWrapper panel = a._vvv1;
            if (panel == null || !panel.IsInitialized()) {
                return;
            }
            Object o = anywheresoftware.b4a.AbsObjectWrapper.getObject(panel);
            if (o instanceof View) {
                animateOut((View) o);
            }
            MAIN.postDelayed(new Runnable() {
                @Override
                public void run() {
                    try {
                        panel.RemoveView();
                    } catch (Throwable ignored) {
                    }
                }
            }, 175);
        } catch (Throwable ignored) {
        }
    }

    /** Entry animation for the settings overlay (called right after it is attached). */
    public static void showSettingsPanelIn() {
        try {
            final com.saminsoftware.remotemediastar.main a =
                    com.saminsoftware.remotemediastar.main.mostCurrent;
            if (a == null) {
                return;
            }
            final anywheresoftware.b4a.objects.PanelWrapper panel = a._vvv1;
            if (panel == null || !panel.IsInitialized()) {
                return;
            }
            Object o = anywheresoftware.b4a.AbsObjectWrapper.getObject(panel);
            if (o instanceof View) {
                animateIn((View) o);
            }
        } catch (Throwable ignored) {
        }
    }

    private static void remove(View v) {
        try {
            if (v == null) {
                return;
            }
            ViewParent p = v.getParent();
            if (p instanceof ViewGroup) {
                ((ViewGroup) p).removeView(v);
            }
        } catch (Throwable ignored) {
        }
    }

    // ------------------------------------------------------------------
    // Transitions
    // ------------------------------------------------------------------

    public static final int EFFECT_FADE = 0;
    public static final int EFFECT_SLIDE_RTL = 1;
    public static final int EFFECT_SLIDE_LTR = 2;
    public static final int EFFECT_ZOOM = 3;
    public static final int EFFECT_FLIP = 4;
    public static final int EFFECT_COUNT = 5;

    private static int effect = EFFECT_SLIDE_RTL;

    public static void setEffect(int e) {
        effect = ((e % EFFECT_COUNT) + EFFECT_COUNT) % EFFECT_COUNT;
    }

    public static int getEffect() {
        return effect;
    }

    /** Fade + slide/zoom intro for every freshly added page. */
    public static void animateIn(View page) {
        if (page == null) {
            return;
        }
        try {
            int w = page.getWidth();
            if (w <= 0) {
                w = page.getResources().getDisplayMetrics().widthPixels;
            }
            AnimationSet set = new AnimationSet(true);
            set.setInterpolator(new DecelerateInterpolator(1.6f));

            AlphaAnimation fade = new AlphaAnimation(0f, 1f);
            fade.setDuration(240);
            set.addAnimation(fade);

            if (effect == EFFECT_SLIDE_LTR) {
                TranslateAnimation slide = new TranslateAnimation(-w * 0.55f, 0f, 0f, 0f);
                slide.setDuration(320);
                slide.setInterpolator(new DecelerateInterpolator(1.4f));
                set.addAnimation(slide);
            } else if (effect == EFFECT_ZOOM) {
                ScaleAnimation scale = new ScaleAnimation(0.82f, 1f, 0.82f, 1f,
                        Animation.RELATIVE_TO_SELF, 0.5f,
                        Animation.RELATIVE_TO_SELF, 0.5f);
                scale.setDuration(300);
                set.addAnimation(scale);
            } else if (effect == EFFECT_FLIP) {
                ScaleAnimation flip = new ScaleAnimation(0.15f, 1f, 1f, 1f,
                        Animation.RELATIVE_TO_SELF, 0.5f,
                        Animation.RELATIVE_TO_SELF, 0.5f);
                flip.setDuration(340);
                set.addAnimation(flip);
            } else if (effect == EFFECT_SLIDE_RTL) {
                TranslateAnimation slide = new TranslateAnimation(w * 0.55f, 0f, 0f, 0f);
                slide.setDuration(320);
                slide.setInterpolator(new DecelerateInterpolator(1.4f));
                set.addAnimation(slide);
                ScaleAnimation scale = new ScaleAnimation(0.94f, 1f, 0.94f, 1f,
                        Animation.RELATIVE_TO_SELF, 0.5f,
                        Animation.RELATIVE_TO_SELF, 0.5f);
                scale.setDuration(320);
                set.addAnimation(scale);
            }
            page.startAnimation(set);
        } catch (Throwable ignored) {
        }
    }

    /** Fade + swipe-out used right before a page is detached. */
    public static void animateOut(final View page) {
        if (page == null) {
            return;
        }
        try {
            AnimationSet set = new AnimationSet(true);
            set.setInterpolator(new AccelerateDecelerateInterpolator());
            AlphaAnimation fade = new AlphaAnimation(1f, 0f);
            fade.setDuration(170);
            set.addAnimation(fade);
            int w = page.getWidth();
            if (w <= 0) {
                w = page.getResources().getDisplayMetrics().widthPixels;
            }
            TranslateAnimation slide = new TranslateAnimation(0f, w * 0.32f, 0f, 0f);
            slide.setDuration(170);
            set.addAnimation(slide);
            set.setFillAfter(true);
            page.startAnimation(set);
        } catch (Throwable ignored) {
        }
    }

    /** Hero intro for the whole remote screen, resolved from the live activity. */
    public static void animateHero() {
        try {
            Activity a = activity();
            View root = a == null ? null : a.findViewById(android.R.id.content);
            animateHero(root);
        } catch (Throwable ignored) {
        }
    }

    /** Hero intro for the whole remote screen (cold start / after a theme switch). */
    public static void animateHero(View root) {
        if (root == null) {
            return;
        }
        try {
            AnimationSet set = new AnimationSet(true);
            set.setInterpolator(new DecelerateInterpolator(1.5f));
            AlphaAnimation fade = new AlphaAnimation(0f, 1f);
            fade.setDuration(420);
            set.addAnimation(fade);
            ScaleAnimation scale = new ScaleAnimation(0.95f, 1f, 0.95f, 1f,
                    Animation.RELATIVE_TO_SELF, 0.5f,
                    Animation.RELATIVE_TO_SELF, 0.5f);
            scale.setDuration(430);
            set.addAnimation(scale);
            root.startAnimation(set);
        } catch (Throwable ignored) {
        }
    }

    /** Staggered entrance for a group of buttons. */
    public static void animateStagger(final ViewGroup container) {
        if (container == null) {
            return;
        }
        try {
            final int n = container.getChildCount();
            for (int i = 0; i < n; i++) {
                final View child = container.getChildAt(i);
                if (child == null) {
                    continue;
                }
                child.setAlpha(0f);
                child.setTranslationY(dp(ctx(), 16));
                MAIN.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            child.animate().alpha(1f).translationY(0f)
                                    .setDuration(260)
                                    .setInterpolator(new DecelerateInterpolator())
                                    .start();
                        } catch (Throwable ignored) {
                        }
                    }
                }, 12L * (i % 18));
            }
        } catch (Throwable ignored) {
        }
    }

    public static void transitionTo(View oldPage, View newPage) {
        animateOut(oldPage);
        animateIn(newPage);
    }

    public static void pulse(View v) {
        if (v == null) {
            return;
        }
        try {
            ScaleAnimation s = new ScaleAnimation(1f, 1.06f, 1f, 1.06f,
                    Animation.RELATIVE_TO_SELF, 0.5f,
                    Animation.RELATIVE_TO_SELF, 0.5f);
            s.setDuration(120);
            s.setRepeatMode(Animation.REVERSE);
            s.setRepeatCount(1);
            v.startAnimation(s);
        } catch (Throwable ignored) {
        }
    }

    /** Modern pressed feedback (subtle scale) - the "alive" touch feel. */
    public static void attachPressFeedback(final View v) {
        if (v == null) {
            return;
        }
        try {
            v.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent event) {
                    switch (event.getActionMasked()) {
                        case MotionEvent.ACTION_DOWN:
                            view.animate().scaleX(0.96f).scaleY(0.96f)
                                    .setDuration(90).start();
                            break;
                        case MotionEvent.ACTION_UP:
                        case MotionEvent.ACTION_CANCEL:
                            view.animate().scaleX(1f).scaleY(1f)
                                    .setDuration(140).start();
                            break;
                        default:
                            break;
                    }
                    return false;
                }
            });
        } catch (Throwable ignored) {
        }
    }

    // ------------------------------------------------------------------
    // Developer page
    // ------------------------------------------------------------------

    public static final String DEV_NAME =
            "\u0627\u0645\u06CC\u0631 \u0635\u062F\u06CC\u0642\u06CC\u0627\u0646";
    public static final String DEV_TEXT =
            "\u0627\u06CC\u0646 \u0628\u0631\u0646\u0627\u0645\u0647 \u062A\u0648\u0633\u0637 "
                    + "\u0627\u0645\u06CC\u0631 \u0635\u062F\u06CC\u0642\u06CC\u0627\u0646 "
                    + "\u0633\u0627\u062E\u062A\u0647 \u0634\u062F\u0647 \u0627\u0633\u062A.";
    public static final String DEV_INSTAGRAM = "x.amirrezaa1";
    public static final String DEV_TELEGRAM = "developer_as";
    public static final String DEV_GITHUB = "developeramira";
    public static final String DEV_INSTAGRAM_URL = "https://instagram.com/x.amirrezaa1";
    public static final String DEV_TELEGRAM_URL = "https://t.me/developer_as";
    public static final String DEV_GITHUB_URL = "https://github.com/developeramira";

    private static View developerOverlay = null;

    public static void showDeveloperPage() {
        try {
            final Activity a = activity();
            if (a == null) {
                return;
            }
            remove(developerOverlay);
            developerOverlay = null;
            View root = a.findViewById(android.R.id.content);
            if (!(root instanceof ViewGroup)) {
                return;
            }
            FrameLayout overlay = buildDeveloperOverlay(a);
            developerOverlay = overlay;
            ((ViewGroup) root).addView(overlay, new ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT));
            animateIn(overlay);
        } catch (Throwable t) {
            toast("\u062E\u0637\u0627 \u062F\u0631 \u0628\u0627\u0632 \u06A9\u0631\u062F\u0646 "
                    + "\u0635\u0641\u062D\u0647 \u062A\u0648\u0633\u0639\u0647\u200C\u062F\u0647\u0646\u062F\u0647");
        }
    }

    public static void hideDeveloperPage() {
        final View v = developerOverlay;
        developerOverlay = null;
        if (v == null) {
            return;
        }
        animateOut(v);
        MAIN.postDelayed(new Runnable() {
            @Override
            public void run() {
                remove(v);
            }
        }, 190);
    }

    private static FrameLayout buildDeveloperOverlay(final Activity a) {
        FrameLayout overlay = new FrameLayout(a);
        overlay.setBackground(pageGradient());
        overlay.setClickable(true);

        ScrollView scroll = new ScrollView(a);
        scroll.setFillViewport(true);
        overlay.addView(scroll, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

        LinearLayout col = new LinearLayout(a);
        col.setOrientation(LinearLayout.VERTICAL);
        col.setGravity(Gravity.CENTER_HORIZONTAL);
        int pad = dp(a, 22);
        col.setPadding(pad, dp(a, 34), pad, dp(a, 30));

        TextView avatar = new TextView(a);
        avatar.setText("\uD83D\uDC68\u200D\uD83D\uDCBB");
        avatar.setTextSize(44);
        avatar.setGravity(Gravity.CENTER);
        GradientDrawable ring = new GradientDrawable(GradientDrawable.Orientation.TL_BR,
                new int[]{color(ACCENT), color(ACCENT_ALT)});
        ring.setShape(GradientDrawable.OVAL);
        avatar.setBackground(ring);
        int size = dp(a, 104);
        LinearLayout.LayoutParams ap = new LinearLayout.LayoutParams(size, size);
        ap.bottomMargin = dp(a, 16);
        col.addView(avatar, ap);

        TextView name = new TextView(a);
        name.setText(DEV_NAME);
        name.setTextColor(color(TEXT_ON_BG));
        name.setTextSize(21);
        name.setTypeface(Typeface.DEFAULT_BOLD);
        name.setGravity(Gravity.CENTER);
        col.addView(name);

        TextView role = new TextView(a);
        role.setText("\u062A\u0648\u0633\u0639\u0647\u200C\u062F\u0647\u0646\u062F\u0647 "
                + "\u0627\u067E\u0644\u06CC\u06A9\u06CC\u0634\u0646");
        role.setTextColor(color(ACCENT));
        role.setTextSize(13);
        role.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams rp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        rp.topMargin = dp(a, 4);
        rp.bottomMargin = dp(a, 20);
        col.addView(role, rp);

        LinearLayout intro = new LinearLayout(a);
        intro.setOrientation(LinearLayout.VERTICAL);
        intro.setBackground(card(color(CARD), alpha(color(CARD_BORDER), 0xCC)));
        int cp = dp(a, 18);
        intro.setPadding(cp, cp, cp, cp);
        TextView introText = new TextView(a);
        introText.setText(DEV_TEXT);
        introText.setTextColor(color(TEXT_ON_BG));
        introText.setTextSize(15);
        introText.setLineSpacing(dp(a, 3), 1f);
        introText.setGravity(Gravity.CENTER);
        intro.addView(introText);
        LinearLayout.LayoutParams ip = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        ip.bottomMargin = dp(a, 24);
        col.addView(intro, ip);

        TextView bridgesTitle = new TextView(a);
        bridgesTitle.setText("\u067E\u0644\u200C\u0647\u0627\u06CC "
                + "\u0627\u0631\u062A\u0628\u0627\u0637\u06CC");
        bridgesTitle.setTextColor(color(TEXT_ON_BG));
        bridgesTitle.setTextSize(16);
        bridgesTitle.setTypeface(Typeface.DEFAULT_BOLD);
        bridgesTitle.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams bp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        bp.bottomMargin = dp(a, 12);
        col.addView(bridgesTitle, bp);

        col.addView(socialRow(a, "\uD83D\uDCF7",
                "\u0627\u06CC\u0646\u0633\u062A\u0627\u06AF\u0631\u0627\u0645",
                DEV_INSTAGRAM, DEV_INSTAGRAM_URL));
        col.addView(socialRow(a, "\u2708",
                "\u062A\u0644\u06AF\u0631\u0627\u0645",
                DEV_TELEGRAM, DEV_TELEGRAM_URL));
        col.addView(socialRow(a, "\uD83D\uDC19",
                "\u06AF\u06CC\u062A\u200C\u0647\u0627\u0628",
                DEV_GITHUB, DEV_GITHUB_URL));

        TextView version = new TextView(a);
        version.setText("MediaStar Remote  \u2022  v15.0.0  \u2022  "
                + "com.developeramira.remotemediastar");
        version.setTextColor(color(TEXT_MUTED));
        version.setTextSize(10);
        version.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams vp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        vp.topMargin = dp(a, 22);
        vp.bottomMargin = dp(a, 10);
        col.addView(version, vp);

        TextView close = new TextView(a);
        close.setText("\u0628\u0627\u0632\u06AF\u0634\u062A");
        close.setTextColor(color(TEXT_ON_ACCENT));
        close.setTextSize(15);
        close.setTypeface(Typeface.DEFAULT_BOLD);
        close.setGravity(Gravity.CENTER);
        close.setPadding(0, dp(a, 14), 0, dp(a, 14));
        GradientDrawable closeBg = new GradientDrawable(GradientDrawable.Orientation.LEFT_RIGHT,
                new int[]{color(ACCENT), color(ACCENT_ALT)});
        closeBg.setCornerRadius(dp(a, 14));
        close.setBackground(closeBg);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pulse(v);
                hideDeveloperPage();
            }
        });
        col.addView(close, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        scroll.addView(col, new ScrollView.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        return overlay;
    }

    private static View socialRow(final Activity a, String icon, String label,
                                  final String handle, final String url) {
        LinearLayout row = new LinearLayout(a);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        GradientDrawable bg = new GradientDrawable(GradientDrawable.Orientation.LEFT_RIGHT,
                new int[]{color(SURFACE), color(SURFACE_ALT)});
        bg.setCornerRadius(dp(a, 14));
        bg.setStroke(Math.max(1, dp(a, 1)), alpha(color(ACCENT), 0x66));
        row.setBackground(bg);
        int p = dp(a, 14);
        row.setPadding(p, p, p, p);
        row.setClickable(true);
        row.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pulse(v);
                openLink(url, handle);
            }
        });

        TextView ic = new TextView(a);
        ic.setText(icon);
        ic.setTextSize(20);
        ic.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams icp = new LinearLayout.LayoutParams(dp(a, 36), dp(a, 36));
        icp.setMargins(0, 0, dp(a, 12), 0);
        row.addView(ic, icp);

        LinearLayout texts = new LinearLayout(a);
        texts.setOrientation(LinearLayout.VERTICAL);

        TextView t1 = new TextView(a);
        t1.setText(label);
        t1.setTextColor(color(TEXT_ON_BG));
        t1.setTextSize(14);
        t1.setTypeface(Typeface.DEFAULT_BOLD);
        texts.addView(t1);

        TextView t2 = new TextView(a);
        t2.setText(handle);
        t2.setTextColor(color(ACCENT));
        t2.setTextSize(12);
        texts.addView(t2);

        row.addView(texts, new LinearLayout.LayoutParams(0,
                ViewGroup.LayoutParams.WRAP_CONTENT, 1f));

        TextView arrow = new TextView(a);
        arrow.setText("\u2190");
        arrow.setTextColor(color(ACCENT));
        arrow.setTextSize(18);
        row.addView(arrow);

        LinearLayout.LayoutParams rlp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        rlp.bottomMargin = dp(a, 10);
        row.setLayoutParams(rlp);
        return row;
    }

    /** Opens one of the developer's social links. */
    public static boolean openLink(String url, String handle) {
        try {
            Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
            Activity a = activity();
            if (a != null) {
                a.startActivity(i);
            } else {
                Context c = ctx();
                if (c == null) {
                    return false;
                }
                i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                c.startActivity(i);
            }
            toast("\u062F\u0631 \u062D\u0627\u0644 \u0628\u0627\u0632 \u06A9\u0631\u062F\u0646 "
                    + handle);
            return true;
        } catch (Throwable t) {
            toast("\u0627\u0645\u06A9\u0627\u0646 \u0628\u0627\u0632 \u06A9\u0631\u062F\u0646 "
                    + "\u0644\u06CC\u0646\u06A9 \u0648\u062C\u0648\u062F \u0646\u062F\u0627\u0631\u062F");
            return false;
        }
    }

    public static void openInstagram() {
        openLink(DEV_INSTAGRAM_URL, DEV_INSTAGRAM);
    }

    public static void openTelegram() {
        openLink(DEV_TELEGRAM_URL, DEV_TELEGRAM);
    }

    public static void openGithub() {
        openLink(DEV_GITHUB_URL, DEV_GITHUB);
    }

    /** Called once from the B4A activity to boot the engine. */
    public static void install() {
        try {
            loadPrefs();
            syncLegacyFlag();
            Activity a = activity();
            if (a != null) {
                applyToWindow(a);
            }
        } catch (Throwable ignored) {
        }
    }

    // ------------------------------------------------------------------
    // Theme picker
    // ------------------------------------------------------------------

    private static View themeOverlay = null;

    public static void showThemeChooser() {
        try {
            final Activity a = activity();
            if (a == null) {
                return;
            }
            remove(themeOverlay);
            themeOverlay = null;
            View root = a.findViewById(android.R.id.content);
            if (!(root instanceof ViewGroup)) {
                return;
            }
            FrameLayout overlay = buildThemeOverlay(a);
            themeOverlay = overlay;
            ((ViewGroup) root).addView(overlay, new ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT));
            animateIn(overlay);
        } catch (Throwable t) {
            toast("\u062E\u0637\u0627 \u062F\u0631 \u0628\u0627\u0632 \u06A9\u0631\u062F\u0646 "
                    + "\u0627\u0646\u062A\u062E\u0627\u0628 \u062A\u0645");
        }
    }

    public static void hideThemeChooser() {
        final View v = themeOverlay;
        themeOverlay = null;
        if (v == null) {
            return;
        }
        animateOut(v);
        MAIN.postDelayed(new Runnable() {
            @Override
            public void run() {
                remove(v);
            }
        }, 190);
    }

    private static FrameLayout buildThemeOverlay(final Activity a) {
        FrameLayout overlay = new FrameLayout(a);
        overlay.setBackground(pageGradient());
        overlay.setClickable(true);

        ScrollView scroll = new ScrollView(a);
        overlay.addView(scroll, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

        LinearLayout col = new LinearLayout(a);
        col.setOrientation(LinearLayout.VERTICAL);
        int pad = dp(a, 18);
        col.setPadding(pad, dp(a, 28), pad, dp(a, 24));

        TextView title = new TextView(a);
        title.setText("\u0641\u0631\u0648\u0634\u06AF\u0627\u0647 \u062A\u0645\u200C\u0647\u0627");
        title.setTextColor(color(TEXT_ON_BG));
        title.setTextSize(20);
        title.setTypeface(Typeface.DEFAULT_BOLD);
        title.setGravity(Gravity.CENTER);
        col.addView(title);

        TextView sub = new TextView(a);
        sub.setText("7 \u062A\u0645 \u0631\u0646\u06AF\u06CC \u0628\u0631\u0627\u06CC "
                + "\u0627\u0646\u062A\u062E\u0627\u0628 \u0634\u0645\u0627\u061B "
                + "\u062A\u063A\u06CC\u06CC\u0631 \u0628\u0644\u0627\u0641\u0627\u0635\u0644\u0647 "
                + "\u0627\u0639\u0645\u0627\u0644 \u0645\u06CC\u200C\u0634\u0648\u062F.");
        sub.setTextColor(color(TEXT_MUTED));
        sub.setTextSize(12);
        sub.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams sp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        sp.topMargin = dp(a, 6);
        sp.bottomMargin = dp(a, 18);
        col.addView(sub, sp);

        String active = getTheme();
        for (int i = 0; i < THEME_IDS.length; i++) {
            col.addView(themeCard(a, i, THEME_IDS[i].equals(active)));
        }

        TextView close = new TextView(a);
        close.setText("\u0628\u0633\u062A\u0646");
        close.setTextColor(color(TEXT_ON_ACCENT));
        close.setTextSize(15);
        close.setTypeface(Typeface.DEFAULT_BOLD);
        close.setGravity(Gravity.CENTER);
        close.setPadding(0, dp(a, 14), 0, dp(a, 14));
        GradientDrawable closeBg = new GradientDrawable(GradientDrawable.Orientation.LEFT_RIGHT,
                new int[]{color(ACCENT), color(ACCENT_ALT)});
        closeBg.setCornerRadius(dp(a, 14));
        close.setBackground(closeBg);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pulse(v);
                hideThemeChooser();
            }
        });
        LinearLayout.LayoutParams clp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        clp.topMargin = dp(a, 16);
        col.addView(close, clp);

        scroll.addView(col, new ScrollView.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        return overlay;
    }

    private static View themeCard(final Activity a, final int index, boolean active) {
        final int[] pal = PALETTES[index];
        LinearLayout row = new LinearLayout(a);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        GradientDrawable bg = new GradientDrawable(GradientDrawable.Orientation.LEFT_RIGHT,
                new int[]{pal[CARD], pal[SURFACE]});
        bg.setCornerRadius(dp(a, 16));
        bg.setStroke(Math.max(1, dp(a, active ? 2 : 1)),
                active ? pal[ACCENT] : alpha(pal[CARD_BORDER], 0xAA));
        row.setBackground(bg);
        int p = dp(a, 12);
        row.setPadding(p, p, p, p);

        LinearLayout sw = new LinearLayout(a);
        sw.setOrientation(LinearLayout.HORIZONTAL);
        int[] dots = {pal[BG_TOP], pal[ACCENT], pal[ACCENT_ALT]};
        for (int d : dots) {
            View dot = new View(a);
            GradientDrawable cg = new GradientDrawable();
            cg.setShape(GradientDrawable.OVAL);
            cg.setColor(d);
            cg.setStroke(Math.max(1, dp(a, 1)), alpha(Color.WHITE, 0x66));
            dot.setBackground(cg);
            LinearLayout.LayoutParams dlp = new LinearLayout.LayoutParams(dp(a, 24), dp(a, 24));
            dlp.setMargins(0, 0, dp(a, 4), 0);
            sw.addView(dot, dlp);
        }
        row.addView(sw, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        LinearLayout texts = new LinearLayout(a);
        texts.setOrientation(LinearLayout.VERTICAL);
        LinearLayout.LayoutParams tlp = new LinearLayout.LayoutParams(0,
                ViewGroup.LayoutParams.WRAP_CONTENT, 1f);
        tlp.setMargins(dp(a, 12), 0, dp(a, 8), 0);

        TextView t1 = new TextView(a);
        t1.setText(THEME_NAMES[index]);
        t1.setTextColor(pal[TEXT_ON_BG]);
        t1.setTextSize(14);
        t1.setTypeface(Typeface.DEFAULT_BOLD);
        texts.addView(t1);

        TextView t2 = new TextView(a);
        t2.setText(THEME_TAGS[index]);
        t2.setTextColor(pal[TEXT_MUTED]);
        t2.setTextSize(11);
        texts.addView(t2);
        row.addView(texts, tlp);

        TextView check = new TextView(a);
        check.setText(active ? "\u2714" : "\u25CB");
        check.setTextColor(active ? pal[ACCENT] : pal[TEXT_MUTED]);
        check.setTextSize(18);
        row.addView(check);

        row.setClickable(true);
        row.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setTheme(THEME_IDS[index]);
                syncLegacyFlag();
                pulse(v);
                toast("\u062A\u0645 \u00AB" + THEME_NAMES[index]
                        + "\u00BB \u0627\u0639\u0645\u0627\u0644 \u0634\u062F");
                hideThemeChooser();
                MAIN.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        applyThemeLive();
                    }
                }, 180);
            }
        });

        LinearLayout.LayoutParams rlp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        rlp.bottomMargin = dp(a, 10);
        row.setLayoutParams(rlp);
        return row;
    }

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------

    public static void toast(final String msg) {
        try {
            MAIN.post(new Runnable() {
                @Override
                public void run() {
                    try {
                        Context c = ctx();
                        if (c != null) {
                            Toast.makeText(c, msg, Toast.LENGTH_SHORT).show();
                        }
                    } catch (Throwable ignored) {
                    }
                }
            });
        } catch (Throwable ignored) {
        }
    }
}
