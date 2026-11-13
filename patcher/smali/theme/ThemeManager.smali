.class public final Lcom/developeramira/remotemediastar/theme/ThemeManager;
.super Ljava/lang/Object;
.source "ThemeManager.java"


# static fields
.field public static final ACCENT:I = 0x9

.field public static final ACCENT_ALT:I = 0xa

.field public static final ACCENT_SOFT:I = 0xb

.field public static final BG_BOTTOM:I = 0x2

.field public static final BG_MID:I = 0x1

.field public static final BG_TOP:I = 0x0

.field public static final CARD:I = 0x7

.field public static final CARD_BORDER:I = 0x8

.field public static final DANGER:I = 0xf

.field public static final DEV_GITHUB:Ljava/lang/String; = "developeramira"

.field public static final DEV_GITHUB_URL:Ljava/lang/String; = "https://github.com/developeramira"

.field public static final DEV_INSTAGRAM:Ljava/lang/String; = "x.amirrezaa1"

.field public static final DEV_INSTAGRAM_URL:Ljava/lang/String; = "https://instagram.com/x.amirrezaa1"

.field public static final DEV_NAME:Ljava/lang/String; = "\u0627\u0645\u06cc\u0631 \u0635\u062f\u06cc\u0642\u06cc\u0627\u0646"

.field public static final DEV_TELEGRAM:Ljava/lang/String; = "developer_as"

.field public static final DEV_TELEGRAM_URL:Ljava/lang/String; = "https://t.me/developer_as"

.field public static final DEV_TEXT:Ljava/lang/String; = "\u0627\u06cc\u0646 \u0628\u0631\u0646\u0627\u0645\u0647 \u062a\u0648\u0633\u0637 \u0627\u0645\u06cc\u0631 \u0635\u062f\u06cc\u0642\u06cc\u0627\u0646 \u0633\u0627\u062e\u062a\u0647 \u0634\u062f\u0647 \u0627\u0633\u062a."

.field public static final EFFECT_COUNT:I = 0x5

.field public static final EFFECT_FADE:I = 0x0

.field public static final EFFECT_FLIP:I = 0x4

.field public static final EFFECT_SLIDE_LTR:I = 0x2

.field public static final EFFECT_SLIDE_RTL:I = 0x1

.field public static final EFFECT_ZOOM:I = 0x3

.field public static final KEY_THEME:Ljava/lang/String; = "theme_id"

.field private static final MAIN:Landroid/os/Handler;

.field private static final PALETTES:[[I

.field public static final PANEL_BOTTOM:I = 0x4

.field public static final PANEL_TOP:I = 0x3

.field public static final PREFS:Ljava/lang/String; = "mediastar_theme_prefs"

.field public static final SLOT_COUNT:I = 0x11

.field public static final SUCCESS:I = 0x10

.field public static final SURFACE:I = 0x5

.field public static final SURFACE_ALT:I = 0x6

.field public static final TEXT_MUTED:I = 0xd

.field public static final TEXT_ON_ACCENT:I = 0xe

.field public static final TEXT_ON_BG:I = 0xc

.field public static final THEME_IDS:[Ljava/lang/String;

.field public static final THEME_NAMES:[Ljava/lang/String;

.field public static final THEME_TAGS:[Ljava/lang/String;

.field private static current:[I

.field private static currentId:Ljava/lang/String;

.field private static developerOverlay:Landroid/view/View;

.field private static effect:I

.field private static loaded:Z

.field private static themeOverlay:Landroid/view/View;


# direct methods
.method static constructor <clinit>()V
    .locals 8

    .line 55
    const-string v0, "light"

    const-string v1, "dark"

    const-string v2, "neon"

    const-string v3, "classic"

    const-string v4, "ocean"

    const-string v5, "sunset"

    const-string v6, "forest"

    filled-new-array/range {v0 .. v6}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_IDS:[Ljava/lang/String;

    .line 60
    const-string v1, "\u062a\u0645 \u0631\u0648\u0634\u0646 \u2013 \u0644\u0648\u062a\u0648\u0633"

    const-string v2, "\u062a\u0645 \u062a\u0627\u0631\u06cc\u06a9 \u0645\u062f\u0631\u0646"

    const-string v3, "\u062a\u0645 \u0646\u0626\u0648\u0646\u06cc"

    const-string v4, "\u062a\u0645 \u06a9\u0644\u0627\u0633\u06cc\u06a9 \u0686\u0648\u0628\u06cc"

    const-string v5, "\u062a\u0645 \u0627\u0642\u06cc\u0627\u0646\u0648\u0633\u06cc"

    const-string v6, "\u062a\u0645 \u063a\u0631\u0648\u0628"

    const-string v7, "\u062a\u0645 \u062c\u0646\u06af\u0644\u06cc \u2013 \u0632\u0645\u0631\u062f"

    filled-new-array/range {v1 .. v7}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_NAMES:[Ljava/lang/String;

    .line 71
    const-string v1, "\u0631\u0648\u0634\u0646\u060c \u06af\u0631\u0645 \u0648 \u062e\u0648\u0627\u0646\u0627"

    const-string v2, "\u0634\u0628\u06af\u0631\u062f\u06cc\u060c \u0645\u062f\u0631\u0646 \u0648 \u0686\u0634\u0645\u200c\u0646\u0648\u0627\u0632"

    const-string v3, "\u062f\u0631\u062e\u0634\u0627\u0646 \u0628\u0627 \u0631\u0646\u06af\u200c\u0647\u0627\u06cc \u0646\u0626\u0648\u0646\u06cc"

    const-string v4, "\u06af\u0631\u0645\u060c \u0686\u0648\u0628\u06cc \u0648 \u0637\u0644\u0627\u06cc\u06cc"

    const-string v5, "\u0622\u0631\u0627\u0645 \u0628\u0627 \u0622\u0628\u06cc \u0627\u0642\u06cc\u0627\u0646\u0648\u0633"

    const-string v6, "\u067e\u0631\u0627\u0646\u0631\u0698\u06cc \u0628\u0627 \u0646\u0627\u0631\u0646\u062c\u06cc \u0648 \u0627\u0631\u063a\u0648\u0627\u0646\u06cc"

    const-string v7, "\u0633\u0628\u0632\u060c \u062a\u0627\u0632\u0647 \u0648 \u0637\u0628\u06cc\u0639\u06cc"

    filled-new-array/range {v1 .. v7}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_TAGS:[Ljava/lang/String;

    .line 101
    const/4 v0, 0x7

    new-array v0, v0, [[I

    const/16 v1, 0x11

    new-array v2, v1, [I

    fill-array-data v2, :array_0

    const/4 v3, 0x0

    aput-object v2, v0, v3

    new-array v4, v1, [I

    fill-array-data v4, :array_1

    const/4 v5, 0x1

    aput-object v4, v0, v5

    new-array v4, v1, [I

    fill-array-data v4, :array_2

    const/4 v6, 0x2

    aput-object v4, v0, v6

    new-array v4, v1, [I

    fill-array-data v4, :array_3

    const/4 v6, 0x3

    aput-object v4, v0, v6

    new-array v4, v1, [I

    fill-array-data v4, :array_4

    const/4 v6, 0x4

    aput-object v4, v0, v6

    new-array v4, v1, [I

    fill-array-data v4, :array_5

    const/4 v6, 0x5

    aput-object v4, v0, v6

    new-array v1, v1, [I

    fill-array-data v1, :array_6

    const/4 v4, 0x6

    aput-object v1, v0, v4

    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->PALETTES:[[I

    .line 132
    sput-object v2, Lcom/developeramira/remotemediastar/theme/ThemeManager;->current:[I

    .line 133
    const-string v0, "light"

    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->currentId:Ljava/lang/String;

    .line 134
    sput-boolean v3, Lcom/developeramira/remotemediastar/theme/ThemeManager;->loaded:Z

    .line 135
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->MAIN:Landroid/os/Handler;

    .line 571
    sput v5, Lcom/developeramira/remotemediastar/theme/ThemeManager;->effect:I

    .line 784
    const/4 v0, 0x0

    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->developerOverlay:Landroid/view/View;

    .line 1066
    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->themeOverlay:Landroid/view/View;

    return-void

    :array_0
    .array-data 4
        0xfdfaf2
        0xf7f1e3
        0xefe4cc
        0xffffff
        0xf5efe2
        0xfffbf3
        0xf3ead8
        0xfffdf8
        0xe3d5b4
        0xc9a227
        0x8c6d1f
        0xf2e3bf
        0x3a3020
        0x7a6a50
        0xfffdf8
        0xd6453f
        0x2e8b57
    .end array-data

    :array_1
    .array-data 4
        0x101019
        0x151f2e
        0xa0e16
        0x1e2a3b
        0x141c28
        0x1a2230    # 2.399987E-39f
        0x223040
        0x1c2636
        0x2e3e52
        0xe7c46b
        0xffd98a
        0x333f52
        0xf1f5fb
        0x9aa8ba
        0x141c28
        0xe05a5a
        0x59c98e
    .end array-data

    :array_2
    .array-data 4
        0xb0614
        0x14092a    # 1.839997E-39f
        0x8040f
        0x241044
        0x150a26
        0x1d0e36
        0x2a1548
        0x1f1038
        0x43267a
        0x22d3ee
        0xff3dcb
        0x2e1a52
        0xf5ecff
        0xb69fd6
        0xa0410
        0xff5c8a
        0x5bffc8
    .end array-data

    :array_3
    .array-data 4
        0x2a1c12
        0x3a2617
        0x1e1409
        0x4a3320
        0x33220f
        0x3d2a18
        0x4f3823
        0x43301c
        0x6b4c2a
        0xd4af37
        0xe8c766
        0x5a3f22
        0xf7ebd3
        0xc3a882
        0x2a1c12
        0xb3462f
        0x6fbf73
    .end array-data

    :array_4
    .array-data 4
        0x61826
        0xb2a3f
        0x4121c
        0xe3550
        0x92538
        0xc2c43
        0x114058
        0xe3348
        0x1a5470
        0x3fc1c9
        0x2a9db5
        0x123f58
        0xe8f7fa
        0x8fb6c4
        0x4121c
        0xe2545a
        0x4fd1a5
    .end array-data

    :array_5
    .array-data 4
        0x2b0f22
        0x4a1633
        0x1a0814
        0x5c2140
        0x38102a
        0x45192f
        0x5a2542
        0x4b1d36
        0x74314f
        0xff8a3d
        0xffb74d
        0x6a2a47
        0xfff3e9
        0xd9a28f
        0x2b0f22
        0xe04b5c
        0x69d08a
    .end array-data

    :array_6
    .array-data 4
        0xa1f16
        0x123024
        0x61510
        0x1a3d2c
        0xf281d
        0x163528
        0x204534
        0x19392a
        0x2c5c44
        0x5bd98b
        0xa3e635
        0x23503c
        0xecf7f0
        0x9bbca9
        0xa1f16
        0xe06c5a
        0x7be495
    .end array-data
.end method

.method private constructor <init>()V
    .locals 0

    .line 137
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 138
    return-void
.end method

.method public static accentColor()I
    .locals 1

    .line 317
    const/16 v0, 0x9

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    return v0
.end method

.method static synthetic access$000(Landroid/view/View;)V
    .locals 0

    .line 50
    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->remove(Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$100()Landroid/os/Handler;
    .locals 1

    .line 50
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->MAIN:Landroid/os/Handler;

    return-object v0
.end method

.method static synthetic access$200()Landroid/content/Context;
    .locals 1

    .line 50
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object v0

    return-object v0
.end method

.method private static activity()Landroid/app/Activity;
    .locals 1

    .line 142
    :try_start_0
    sget-object v0, Lcom/developeramira/remotemediastar/main;->mostCurrent:Lcom/developeramira/remotemediastar/main;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object v0

    .line 143
    :catchall_0
    move-exception v0

    .line 144
    const/4 v0, 0x0

    return-object v0
.end method

.method public static alpha(II)I
    .locals 1

    .line 375
    shl-int/lit8 p1, p1, 0x18

    const v0, 0xffffff

    and-int/2addr p0, v0

    or-int/2addr p0, p1

    return p0
.end method

.method public static animateHero()V
    .locals 2

    .line 658
    :try_start_0
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->activity()Landroid/app/Activity;

    move-result-object v0

    .line 659
    if-nez v0, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    const v1, 0x1020002

    invoke-virtual {v0, v1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    .line 660
    :goto_0
    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->animateHero(Landroid/view/View;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 662
    goto :goto_1

    .line 661
    :catchall_0
    move-exception v0

    .line 663
    :goto_1
    return-void
.end method

.method public static animateHero(Landroid/view/View;)V
    .locals 13

    .line 667
    if-nez p0, :cond_0

    .line 668
    return-void

    .line 671
    :cond_0
    :try_start_0
    new-instance v0, Landroid/view/animation/AnimationSet;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/view/animation/AnimationSet;-><init>(Z)V

    .line 672
    new-instance v1, Landroid/view/animation/DecelerateInterpolator;

    const/high16 v2, 0x3fc00000    # 1.5f

    invoke-direct {v1, v2}, Landroid/view/animation/DecelerateInterpolator;-><init>(F)V

    invoke-virtual {v0, v1}, Landroid/view/animation/AnimationSet;->setInterpolator(Landroid/view/animation/Interpolator;)V

    .line 673
    new-instance v1, Landroid/view/animation/AlphaAnimation;

    const/4 v2, 0x0

    const/high16 v3, 0x3f800000    # 1.0f

    invoke-direct {v1, v2, v3}, Landroid/view/animation/AlphaAnimation;-><init>(FF)V

    .line 674
    const-wide/16 v2, 0x1a4

    invoke-virtual {v1, v2, v3}, Landroid/view/animation/AlphaAnimation;->setDuration(J)V

    .line 675
    invoke-virtual {v0, v1}, Landroid/view/animation/AnimationSet;->addAnimation(Landroid/view/animation/Animation;)V

    .line 676
    new-instance v1, Landroid/view/animation/ScaleAnimation;

    const v5, 0x3f733333    # 0.95f

    const/high16 v6, 0x3f800000    # 1.0f

    const v7, 0x3f733333    # 0.95f

    const/high16 v8, 0x3f800000    # 1.0f

    const/4 v9, 0x1

    const/high16 v10, 0x3f000000    # 0.5f

    const/4 v11, 0x1

    const/high16 v12, 0x3f000000    # 0.5f

    move-object v4, v1

    invoke-direct/range {v4 .. v12}, Landroid/view/animation/ScaleAnimation;-><init>(FFFFIFIF)V

    .line 679
    const-wide/16 v2, 0x1ae

    invoke-virtual {v1, v2, v3}, Landroid/view/animation/ScaleAnimation;->setDuration(J)V

    .line 680
    invoke-virtual {v0, v1}, Landroid/view/animation/AnimationSet;->addAnimation(Landroid/view/animation/Animation;)V

    .line 681
    invoke-virtual {p0, v0}, Landroid/view/View;->startAnimation(Landroid/view/animation/Animation;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 683
    goto :goto_0

    .line 682
    :catchall_0
    move-exception p0

    .line 684
    :goto_0
    return-void
.end method

.method public static animateIn(Landroid/view/View;)V
    .locals 20

    .line 583
    move-object/from16 v0, p0

    if-nez v0, :cond_0

    .line 584
    return-void

    .line 587
    :cond_0
    :try_start_0
    invoke-virtual/range {p0 .. p0}, Landroid/view/View;->getWidth()I

    move-result v1

    .line 588
    if-gtz v1, :cond_1

    .line 589
    invoke-virtual/range {p0 .. p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    iget v1, v1, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 591
    :cond_1
    new-instance v2, Landroid/view/animation/AnimationSet;

    const/4 v3, 0x1

    invoke-direct {v2, v3}, Landroid/view/animation/AnimationSet;-><init>(Z)V

    .line 592
    new-instance v4, Landroid/view/animation/DecelerateInterpolator;

    const v5, 0x3fcccccd    # 1.6f

    invoke-direct {v4, v5}, Landroid/view/animation/DecelerateInterpolator;-><init>(F)V

    invoke-virtual {v2, v4}, Landroid/view/animation/AnimationSet;->setInterpolator(Landroid/view/animation/Interpolator;)V

    .line 594
    new-instance v4, Landroid/view/animation/AlphaAnimation;

    const/high16 v5, 0x3f800000    # 1.0f

    const/4 v6, 0x0

    invoke-direct {v4, v6, v5}, Landroid/view/animation/AlphaAnimation;-><init>(FF)V

    .line 595
    const-wide/16 v7, 0xf0

    invoke-virtual {v4, v7, v8}, Landroid/view/animation/AlphaAnimation;->setDuration(J)V

    .line 596
    invoke-virtual {v2, v4}, Landroid/view/animation/AnimationSet;->addAnimation(Landroid/view/animation/Animation;)V

    .line 598
    sget v4, Lcom/developeramira/remotemediastar/theme/ThemeManager;->effect:I

    const/4 v5, 0x2

    const v7, 0x3fb33333    # 1.4f

    const v8, 0x3f0ccccd    # 0.55f

    const-wide/16 v9, 0x140

    if-ne v4, v5, :cond_2

    .line 599
    new-instance v3, Landroid/view/animation/TranslateAnimation;

    neg-int v1, v1

    int-to-float v1, v1

    mul-float v1, v1, v8

    invoke-direct {v3, v1, v6, v6, v6}, Landroid/view/animation/TranslateAnimation;-><init>(FFFF)V

    .line 600
    invoke-virtual {v3, v9, v10}, Landroid/view/animation/TranslateAnimation;->setDuration(J)V

    .line 601
    new-instance v1, Landroid/view/animation/DecelerateInterpolator;

    invoke-direct {v1, v7}, Landroid/view/animation/DecelerateInterpolator;-><init>(F)V

    invoke-virtual {v3, v1}, Landroid/view/animation/TranslateAnimation;->setInterpolator(Landroid/view/animation/Interpolator;)V

    .line 602
    invoke-virtual {v2, v3}, Landroid/view/animation/AnimationSet;->addAnimation(Landroid/view/animation/Animation;)V

    .line 603
    goto/16 :goto_1

    :cond_2
    const/4 v5, 0x3

    if-ne v4, v5, :cond_3

    .line 604
    new-instance v1, Landroid/view/animation/ScaleAnimation;

    const v12, 0x3f51eb85    # 0.82f

    const/high16 v13, 0x3f800000    # 1.0f

    const v14, 0x3f51eb85    # 0.82f

    const/high16 v15, 0x3f800000    # 1.0f

    const/16 v16, 0x1

    const/high16 v17, 0x3f000000    # 0.5f

    const/16 v18, 0x1

    const/high16 v19, 0x3f000000    # 0.5f

    move-object v11, v1

    invoke-direct/range {v11 .. v19}, Landroid/view/animation/ScaleAnimation;-><init>(FFFFIFIF)V

    .line 607
    const-wide/16 v3, 0x12c

    invoke-virtual {v1, v3, v4}, Landroid/view/animation/ScaleAnimation;->setDuration(J)V

    .line 608
    invoke-virtual {v2, v1}, Landroid/view/animation/AnimationSet;->addAnimation(Landroid/view/animation/Animation;)V

    .line 609
    goto :goto_1

    :cond_3
    const/4 v5, 0x4

    if-ne v4, v5, :cond_4

    .line 610
    new-instance v1, Landroid/view/animation/ScaleAnimation;

    const v12, 0x3e19999a    # 0.15f

    const/high16 v13, 0x3f800000    # 1.0f

    const/high16 v14, 0x3f800000    # 1.0f

    const/high16 v15, 0x3f800000    # 1.0f

    const/16 v16, 0x1

    const/high16 v17, 0x3f000000    # 0.5f

    const/16 v18, 0x1

    const/high16 v19, 0x3f000000    # 0.5f

    move-object v11, v1

    invoke-direct/range {v11 .. v19}, Landroid/view/animation/ScaleAnimation;-><init>(FFFFIFIF)V

    .line 613
    const-wide/16 v3, 0x154

    invoke-virtual {v1, v3, v4}, Landroid/view/animation/ScaleAnimation;->setDuration(J)V

    .line 614
    invoke-virtual {v2, v1}, Landroid/view/animation/AnimationSet;->addAnimation(Landroid/view/animation/Animation;)V

    goto :goto_0

    .line 615
    :cond_4
    if-ne v4, v3, :cond_5

    .line 616
    new-instance v3, Landroid/view/animation/TranslateAnimation;

    int-to-float v1, v1

    mul-float v1, v1, v8

    invoke-direct {v3, v1, v6, v6, v6}, Landroid/view/animation/TranslateAnimation;-><init>(FFFF)V

    .line 617
    invoke-virtual {v3, v9, v10}, Landroid/view/animation/TranslateAnimation;->setDuration(J)V

    .line 618
    new-instance v1, Landroid/view/animation/DecelerateInterpolator;

    invoke-direct {v1, v7}, Landroid/view/animation/DecelerateInterpolator;-><init>(F)V

    invoke-virtual {v3, v1}, Landroid/view/animation/TranslateAnimation;->setInterpolator(Landroid/view/animation/Interpolator;)V

    .line 619
    invoke-virtual {v2, v3}, Landroid/view/animation/AnimationSet;->addAnimation(Landroid/view/animation/Animation;)V

    .line 620
    new-instance v1, Landroid/view/animation/ScaleAnimation;

    const v12, 0x3f70a3d7    # 0.94f

    const/high16 v13, 0x3f800000    # 1.0f

    const v14, 0x3f70a3d7    # 0.94f

    const/high16 v15, 0x3f800000    # 1.0f

    const/16 v16, 0x1

    const/high16 v17, 0x3f000000    # 0.5f

    const/16 v18, 0x1

    const/high16 v19, 0x3f000000    # 0.5f

    move-object v11, v1

    invoke-direct/range {v11 .. v19}, Landroid/view/animation/ScaleAnimation;-><init>(FFFFIFIF)V

    .line 623
    invoke-virtual {v1, v9, v10}, Landroid/view/animation/ScaleAnimation;->setDuration(J)V

    .line 624
    invoke-virtual {v2, v1}, Landroid/view/animation/AnimationSet;->addAnimation(Landroid/view/animation/Animation;)V

    goto :goto_1

    .line 615
    :cond_5
    :goto_0
    nop

    .line 626
    :goto_1
    invoke-virtual {v0, v2}, Landroid/view/View;->startAnimation(Landroid/view/animation/Animation;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 628
    goto :goto_2

    .line 627
    :catchall_0
    move-exception v0

    .line 629
    :goto_2
    return-void
.end method

.method public static animateOut(Landroid/view/View;)V
    .locals 8

    .line 633
    if-nez p0, :cond_0

    .line 634
    return-void

    .line 637
    :cond_0
    :try_start_0
    new-instance v0, Landroid/view/animation/AnimationSet;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/view/animation/AnimationSet;-><init>(Z)V

    .line 638
    new-instance v2, Landroid/view/animation/AccelerateDecelerateInterpolator;

    invoke-direct {v2}, Landroid/view/animation/AccelerateDecelerateInterpolator;-><init>()V

    invoke-virtual {v0, v2}, Landroid/view/animation/AnimationSet;->setInterpolator(Landroid/view/animation/Interpolator;)V

    .line 639
    new-instance v2, Landroid/view/animation/AlphaAnimation;

    const/high16 v3, 0x3f800000    # 1.0f

    const/4 v4, 0x0

    invoke-direct {v2, v3, v4}, Landroid/view/animation/AlphaAnimation;-><init>(FF)V

    .line 640
    const-wide/16 v5, 0xaa

    invoke-virtual {v2, v5, v6}, Landroid/view/animation/AlphaAnimation;->setDuration(J)V

    .line 641
    invoke-virtual {v0, v2}, Landroid/view/animation/AnimationSet;->addAnimation(Landroid/view/animation/Animation;)V

    .line 642
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v2

    .line 643
    if-gtz v2, :cond_1

    .line 644
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v2

    iget v2, v2, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 646
    :cond_1
    new-instance v3, Landroid/view/animation/TranslateAnimation;

    int-to-float v2, v2

    const v7, 0x3ea3d70a    # 0.32f

    mul-float v2, v2, v7

    invoke-direct {v3, v4, v2, v4, v4}, Landroid/view/animation/TranslateAnimation;-><init>(FFFF)V

    .line 647
    invoke-virtual {v3, v5, v6}, Landroid/view/animation/TranslateAnimation;->setDuration(J)V

    .line 648
    invoke-virtual {v0, v3}, Landroid/view/animation/AnimationSet;->addAnimation(Landroid/view/animation/Animation;)V

    .line 649
    invoke-virtual {v0, v1}, Landroid/view/animation/AnimationSet;->setFillAfter(Z)V

    .line 650
    invoke-virtual {p0, v0}, Landroid/view/View;->startAnimation(Landroid/view/animation/Animation;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 652
    goto :goto_0

    .line 651
    :catchall_0
    move-exception p0

    .line 653
    :goto_0
    return-void
.end method

.method public static animateStagger(Landroid/view/ViewGroup;)V
    .locals 9

    .line 688
    if-nez p0, :cond_0

    .line 689
    return-void

    .line 692
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    .line 693
    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_2

    .line 694
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 695
    if-nez v2, :cond_1

    .line 696
    goto :goto_1

    .line 698
    :cond_1
    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/view/View;->setAlpha(F)V

    .line 699
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object v3

    const/16 v4, 0x10

    invoke-static {v3, v4}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v2, v3}, Landroid/view/View;->setTranslationY(F)V

    .line 700
    sget-object v3, Lcom/developeramira/remotemediastar/theme/ThemeManager;->MAIN:Landroid/os/Handler;

    new-instance v4, Lcom/developeramira/remotemediastar/theme/ThemeManager$2;

    invoke-direct {v4, v2}, Lcom/developeramira/remotemediastar/theme/ThemeManager$2;-><init>(Landroid/view/View;)V

    rem-int/lit8 v2, v1, 0x12

    int-to-long v5, v2

    const-wide/16 v7, 0xc

    mul-long v5, v5, v7

    invoke-virtual {v3, v4, v5, v6}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 693
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 714
    :cond_2
    goto :goto_2

    .line 713
    :catchall_0
    move-exception p0

    .line 715
    :goto_2
    return-void
.end method

.method public static applyThemeLive()V
    .locals 2

    .line 484
    :try_start_0
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->themeOverlay:Landroid/view/View;

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->remove(Landroid/view/View;)V

    .line 485
    const/4 v0, 0x0

    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->themeOverlay:Landroid/view/View;

    .line 486
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->activity()Landroid/app/Activity;

    move-result-object v1

    .line 487
    if-eqz v1, :cond_0

    .line 488
    invoke-static {v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->applyToWindow(Landroid/app/Activity;)V

    .line 490
    :cond_0
    invoke-static {}, Lcom/developeramira/remotemediastar/main;->_vv5()Ljava/lang/String;

    .line 491
    if-nez v1, :cond_1

    goto :goto_0

    :cond_1
    const v0, 0x1020002

    invoke-virtual {v1, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    .line 492
    :goto_0
    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->animateHero(Landroid/view/View;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 495
    goto :goto_1

    .line 493
    :catchall_0
    move-exception v0

    .line 494
    const-string v0, "\u062a\u0645 \u0627\u0639\u0645\u0627\u0644 \u0634\u062f"

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->toast(Ljava/lang/String;)V

    .line 496
    :goto_1
    return-void
.end method

.method public static applyToWindow(Landroid/app/Activity;)V
    .locals 2

    .line 456
    :try_start_0
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object p0

    .line 457
    if-nez p0, :cond_0

    .line 458
    return-void

    .line 460
    :cond_0
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->pageGradient()Landroid/graphics/drawable/GradientDrawable;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 461
    nop

    .line 462
    const/high16 v0, -0x80000000

    invoke-virtual {p0, v0}, Landroid/view/Window;->addFlags(I)V

    .line 463
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    invoke-virtual {p0, v0}, Landroid/view/Window;->setStatusBarColor(I)V

    .line 464
    const/4 v0, 0x2

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    invoke-virtual {p0, v0}, Landroid/view/Window;->setNavigationBarColor(I)V

    .line 465
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 466
    invoke-virtual {p0}, Landroid/view/View;->getSystemUiVisibility()I

    move-result v0

    .line 467
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->isDark()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 468
    and-int/lit16 v0, v0, -0x2001

    goto :goto_0

    .line 470
    :cond_1
    or-int/lit16 v0, v0, 0x2000

    .line 472
    :goto_0
    invoke-virtual {p0, v0}, Landroid/view/View;->setSystemUiVisibility(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 475
    goto :goto_1

    .line 474
    :catchall_0
    move-exception p0

    .line 476
    :goto_1
    return-void
.end method

.method public static attachPressFeedback(Landroid/view/View;)V
    .locals 1

    .line 740
    if-nez p0, :cond_0

    .line 741
    return-void

    .line 744
    :cond_0
    :try_start_0
    new-instance v0, Lcom/developeramira/remotemediastar/theme/ThemeManager$3;

    invoke-direct {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager$3;-><init>()V

    invoke-virtual {p0, v0}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 764
    goto :goto_0

    .line 763
    :catchall_0
    move-exception p0

    .line 765
    :goto_0
    return-void
.end method

.method public static blend(IIF)I
    .locals 4

    .line 364
    invoke-static {p0}, Landroid/graphics/Color;->red(I)I

    move-result v0

    int-to-float v0, v0

    const/high16 v1, 0x3f800000    # 1.0f

    sub-float/2addr v1, p2

    mul-float v0, v0, v1

    invoke-static {p1}, Landroid/graphics/Color;->red(I)I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p2

    add-float/2addr v0, v2

    .line 365
    invoke-static {p0}, Landroid/graphics/Color;->green(I)I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, v1

    invoke-static {p1}, Landroid/graphics/Color;->green(I)I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, p2

    add-float/2addr v2, v3

    .line 366
    invoke-static {p0}, Landroid/graphics/Color;->blue(I)I

    move-result p0

    int-to-float p0, p0

    mul-float p0, p0, v1

    invoke-static {p1}, Landroid/graphics/Color;->blue(I)I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p2

    add-float/2addr p0, p1

    .line 367
    float-to-int p1, v0

    invoke-static {p1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->clamp(I)I

    move-result p1

    float-to-int p2, v2

    invoke-static {p2}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->clamp(I)I

    move-result p2

    float-to-int p0, p0

    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->clamp(I)I

    move-result p0

    invoke-static {p1, p2, p0}, Landroid/graphics/Color;->rgb(III)I

    move-result p0

    return p0
.end method

.method private static buildDeveloperOverlay(Landroid/app/Activity;)Landroid/widget/FrameLayout;
    .locals 15

    .line 826
    new-instance v0, Landroid/widget/FrameLayout;

    invoke-direct {v0, p0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 827
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->pageGradient()Landroid/graphics/drawable/GradientDrawable;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 828
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setClickable(Z)V

    .line 830
    new-instance v2, Landroid/widget/ScrollView;

    invoke-direct {v2, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    .line 831
    invoke-virtual {v2, v1}, Landroid/widget/ScrollView;->setFillViewport(Z)V

    .line 832
    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v4, -0x1

    invoke-direct {v3, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v2, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 835
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 836
    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 837
    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 838
    const/16 v5, 0x16

    invoke-static {p0, v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v6

    .line 839
    const/16 v7, 0x22

    invoke-static {p0, v7}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v7

    const/16 v8, 0x1e

    invoke-static {p0, v8}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v8

    invoke-virtual {v3, v6, v7, v6, v8}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 841
    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 842
    const-string v7, "\ud83d\udc68\u200d\ud83d\udcbb"

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 843
    const/high16 v7, 0x42300000    # 44.0f

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextSize(F)V

    .line 844
    const/16 v7, 0x11

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 845
    new-instance v8, Landroid/graphics/drawable/GradientDrawable;

    sget-object v9, Landroid/graphics/drawable/GradientDrawable$Orientation;->TL_BR:Landroid/graphics/drawable/GradientDrawable$Orientation;

    .line 846
    const/16 v10, 0x9

    invoke-static {v10}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v11

    const/16 v12, 0xa

    invoke-static {v12}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v13

    filled-new-array {v11, v13}, [I

    move-result-object v11

    invoke-direct {v8, v9, v11}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    .line 847
    invoke-virtual {v8, v1}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    .line 848
    invoke-virtual {v6, v8}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 849
    const/16 v8, 0x68

    invoke-static {p0, v8}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v8

    .line 850
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v9, v8, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 851
    const/16 v8, 0x10

    invoke-static {p0, v8}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v8

    iput v8, v9, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    .line 852
    invoke-virtual {v3, v6, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 854
    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 855
    const-string v8, "\u0627\u0645\u06cc\u0631 \u0635\u062f\u06cc\u0642\u06cc\u0627\u0646"

    invoke-virtual {v6, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 856
    const/16 v8, 0xc

    invoke-static {v8}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v9

    invoke-virtual {v6, v9}, Landroid/widget/TextView;->setTextColor(I)V

    .line 857
    const/high16 v9, 0x41a80000    # 21.0f

    invoke-virtual {v6, v9}, Landroid/widget/TextView;->setTextSize(F)V

    .line 858
    sget-object v9, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v6, v9}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 859
    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 860
    invoke-virtual {v3, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 862
    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 863
    const-string v9, "\u062a\u0648\u0633\u0639\u0647\u200c\u062f\u0647\u0646\u062f\u0647 \u0627\u067e\u0644\u06cc\u06a9\u06cc\u0634\u0646"

    invoke-virtual {v6, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 865
    invoke-static {v10}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v9

    invoke-virtual {v6, v9}, Landroid/widget/TextView;->setTextColor(I)V

    .line 866
    const/high16 v9, 0x41500000    # 13.0f

    invoke-virtual {v6, v9}, Landroid/widget/TextView;->setTextSize(F)V

    .line 867
    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 868
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v11, -0x2

    invoke-direct {v9, v11, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 870
    const/4 v13, 0x4

    invoke-static {p0, v13}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v13

    iput v13, v9, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 871
    const/16 v13, 0x14

    invoke-static {p0, v13}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v13

    iput v13, v9, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    .line 872
    invoke-virtual {v3, v6, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 874
    new-instance v6, Landroid/widget/LinearLayout;

    invoke-direct {v6, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 875
    invoke-virtual {v6, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 876
    const/4 v1, 0x7

    invoke-static {v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v1

    const/16 v9, 0x8

    invoke-static {v9}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v9

    const/16 v13, 0xcc

    invoke-static {v9, v13}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->alpha(II)I

    move-result v9

    invoke-static {v1, v9}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->card(II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v1

    invoke-virtual {v6, v1}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 877
    const/16 v1, 0x12

    invoke-static {p0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v1

    .line 878
    invoke-virtual {v6, v1, v1, v1, v1}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 879
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 880
    const-string v9, "\u0627\u06cc\u0646 \u0628\u0631\u0646\u0627\u0645\u0647 \u062a\u0648\u0633\u0637 \u0627\u0645\u06cc\u0631 \u0635\u062f\u06cc\u0642\u06cc\u0627\u0646 \u0633\u0627\u062e\u062a\u0647 \u0634\u062f\u0647 \u0627\u0633\u062a."

    invoke-virtual {v1, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 881
    invoke-static {v8}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v9

    invoke-virtual {v1, v9}, Landroid/widget/TextView;->setTextColor(I)V

    .line 882
    const/high16 v9, 0x41700000    # 15.0f

    invoke-virtual {v1, v9}, Landroid/widget/TextView;->setTextSize(F)V

    .line 883
    const/4 v13, 0x3

    invoke-static {p0, v13}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v13

    int-to-float v13, v13

    const/high16 v14, 0x3f800000    # 1.0f

    invoke-virtual {v1, v13, v14}, Landroid/widget/TextView;->setLineSpacing(FF)V

    .line 884
    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 885
    invoke-virtual {v6, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 886
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v1, v4, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 888
    const/16 v13, 0x18

    invoke-static {p0, v13}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v13

    iput v13, v1, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    .line 889
    invoke-virtual {v3, v6, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 891
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 892
    const-string v6, "\u067e\u0644\u200c\u0647\u0627\u06cc \u0627\u0631\u062a\u0628\u0627\u0637\u06cc"

    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 894
    invoke-static {v8}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v6

    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setTextColor(I)V

    .line 895
    const/high16 v6, 0x41800000    # 16.0f

    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setTextSize(F)V

    .line 896
    sget-object v6, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 897
    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 898
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v6, v4, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 900
    invoke-static {p0, v8}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v8

    iput v8, v6, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    .line 901
    invoke-virtual {v3, v1, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 903
    const-string v1, "x.amirrezaa1"

    const-string v6, "https://instagram.com/x.amirrezaa1"

    const-string v8, "\ud83d\udcf7"

    const-string v13, "\u0627\u06cc\u0646\u0633\u062a\u0627\u06af\u0631\u0627\u0645"

    invoke-static {p0, v8, v13, v1, v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->socialRow(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 906
    const-string v1, "developer_as"

    const-string v6, "https://t.me/developer_as"

    const-string v8, "\u2708"

    const-string v13, "\u062a\u0644\u06af\u0631\u0627\u0645"

    invoke-static {p0, v8, v13, v1, v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->socialRow(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 909
    const-string v1, "developeramira"

    const-string v6, "https://github.com/developeramira"

    const-string v8, "\ud83d\udc19"

    const-string v13, "\u06af\u06cc\u062a\u200c\u0647\u0627\u0628"

    invoke-static {p0, v8, v13, v1, v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->socialRow(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 913
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 914
    const-string v6, "MediaStar Remote  \u2022  v15.0.0  \u2022  com.developeramira.remotemediastar"

    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 916
    const/16 v6, 0xd

    invoke-static {v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v6

    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setTextColor(I)V

    .line 917
    const/high16 v6, 0x41200000    # 10.0f

    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setTextSize(F)V

    .line 918
    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 919
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v6, v4, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 921
    invoke-static {p0, v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v5

    iput v5, v6, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 922
    invoke-static {p0, v12}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v5

    iput v5, v6, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    .line 923
    invoke-virtual {v3, v1, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 925
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 926
    const-string v5, "\u0628\u0627\u0632\u06af\u0634\u062a"

    invoke-virtual {v1, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 927
    const/16 v5, 0xe

    invoke-static {v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v6

    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setTextColor(I)V

    .line 928
    invoke-virtual {v1, v9}, Landroid/widget/TextView;->setTextSize(F)V

    .line 929
    sget-object v6, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 930
    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 931
    invoke-static {p0, v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v6

    invoke-static {p0, v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v7

    const/4 v8, 0x0

    invoke-virtual {v1, v8, v6, v8, v7}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 932
    new-instance v6, Landroid/graphics/drawable/GradientDrawable;

    sget-object v7, Landroid/graphics/drawable/GradientDrawable$Orientation;->LEFT_RIGHT:Landroid/graphics/drawable/GradientDrawable$Orientation;

    .line 933
    invoke-static {v10}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v8

    invoke-static {v12}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v9

    filled-new-array {v8, v9}, [I

    move-result-object v8

    invoke-direct {v6, v7, v8}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    .line 934
    invoke-static {p0, v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result p0

    int-to-float p0, p0

    invoke-virtual {v6, p0}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 935
    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 936
    new-instance p0, Lcom/developeramira/remotemediastar/theme/ThemeManager$5;

    invoke-direct {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager$5;-><init>()V

    invoke-virtual {v1, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 943
    new-instance p0, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {p0, v4, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v3, v1, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 946
    new-instance p0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p0, v4, v11}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3, p0}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 948
    return-object v0
.end method

.method private static buildThemeOverlay(Landroid/app/Activity;)Landroid/widget/FrameLayout;
    .locals 11

    .line 1108
    new-instance v0, Landroid/widget/FrameLayout;

    invoke-direct {v0, p0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 1109
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->pageGradient()Landroid/graphics/drawable/GradientDrawable;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 1110
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setClickable(Z)V

    .line 1112
    new-instance v2, Landroid/widget/ScrollView;

    invoke-direct {v2, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    .line 1113
    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v4, -0x1

    invoke-direct {v3, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v2, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1116
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 1117
    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 1118
    const/16 v1, 0x12

    invoke-static {p0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v5

    .line 1119
    const/16 v6, 0x1c

    invoke-static {p0, v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v6

    const/16 v7, 0x18

    invoke-static {p0, v7}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v7

    invoke-virtual {v3, v5, v6, v5, v7}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 1121
    new-instance v5, Landroid/widget/TextView;

    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 1122
    const-string v6, "\u0641\u0631\u0648\u0634\u06af\u0627\u0647 \u062a\u0645\u200c\u0647\u0627"

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1123
    const/16 v6, 0xc

    invoke-static {v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v6

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextColor(I)V

    .line 1124
    const/high16 v6, 0x41a00000    # 20.0f

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V

    .line 1125
    sget-object v6, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 1126
    const/16 v6, 0x11

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setGravity(I)V

    .line 1127
    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1129
    new-instance v5, Landroid/widget/TextView;

    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 1130
    const-string v7, "7 \u062a\u0645 \u0631\u0646\u06af\u06cc \u0628\u0631\u0627\u06cc \u0627\u0646\u062a\u062e\u0627\u0628 \u0634\u0645\u0627\u061b \u062a\u063a\u06cc\u06cc\u0631 \u0628\u0644\u0627\u0641\u0627\u0635\u0644\u0647 \u0627\u0639\u0645\u0627\u0644 \u0645\u06cc\u200c\u0634\u0648\u062f."

    invoke-virtual {v5, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1134
    const/16 v7, 0xd

    invoke-static {v7}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v7

    invoke-virtual {v5, v7}, Landroid/widget/TextView;->setTextColor(I)V

    .line 1135
    const/high16 v7, 0x41400000    # 12.0f

    invoke-virtual {v5, v7}, Landroid/widget/TextView;->setTextSize(F)V

    .line 1136
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setGravity(I)V

    .line 1137
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v8, -0x2

    invoke-direct {v7, v4, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 1139
    const/4 v9, 0x6

    invoke-static {p0, v9}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v9

    iput v9, v7, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 1140
    invoke-static {p0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v1

    iput v1, v7, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    .line 1141
    invoke-virtual {v3, v5, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1143
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->getTheme()Ljava/lang/String;

    move-result-object v1

    .line 1144
    const/4 v5, 0x0

    const/4 v7, 0x0

    :goto_0
    sget-object v9, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_IDS:[Ljava/lang/String;

    array-length v10, v9

    if-ge v7, v10, :cond_0

    .line 1145
    aget-object v9, v9, v7

    invoke-virtual {v9, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    invoke-static {p0, v7, v9}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->themeCard(Landroid/app/Activity;IZ)Landroid/view/View;

    move-result-object v9

    invoke-virtual {v3, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1144
    add-int/lit8 v7, v7, 0x1

    goto :goto_0

    .line 1148
    :cond_0
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 1149
    const-string v7, "\u0628\u0633\u062a\u0646"

    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1150
    const/16 v7, 0xe

    invoke-static {v7}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v9

    invoke-virtual {v1, v9}, Landroid/widget/TextView;->setTextColor(I)V

    .line 1151
    const/high16 v9, 0x41700000    # 15.0f

    invoke-virtual {v1, v9}, Landroid/widget/TextView;->setTextSize(F)V

    .line 1152
    sget-object v9, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v1, v9}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 1153
    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setGravity(I)V

    .line 1154
    invoke-static {p0, v7}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v6

    invoke-static {p0, v7}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v9

    invoke-virtual {v1, v5, v6, v5, v9}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 1155
    new-instance v5, Landroid/graphics/drawable/GradientDrawable;

    sget-object v6, Landroid/graphics/drawable/GradientDrawable$Orientation;->LEFT_RIGHT:Landroid/graphics/drawable/GradientDrawable$Orientation;

    .line 1156
    const/16 v9, 0x9

    invoke-static {v9}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v9

    const/16 v10, 0xa

    invoke-static {v10}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v10

    filled-new-array {v9, v10}, [I

    move-result-object v9

    invoke-direct {v5, v6, v9}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    .line 1157
    invoke-static {p0, v7}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v6

    int-to-float v6, v6

    invoke-virtual {v5, v6}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 1158
    invoke-virtual {v1, v5}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 1159
    new-instance v5, Lcom/developeramira/remotemediastar/theme/ThemeManager$8;

    invoke-direct {v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager$8;-><init>()V

    invoke-virtual {v1, v5}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 1166
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v5, v4, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 1168
    const/16 v6, 0x10

    invoke-static {p0, v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result p0

    iput p0, v5, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 1169
    invoke-virtual {v3, v1, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1171
    new-instance p0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p0, v4, v8}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3, p0}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1173
    return-object v0
.end method

.method public static button(Ljava/lang/String;)Landroid/graphics/drawable/GradientDrawable;
    .locals 4

    .line 419
    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->panelButtonColor(Ljava/lang/String;)I

    move-result p0

    .line 420
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    sget-object v1, Landroid/graphics/drawable/GradientDrawable$Orientation;->TOP_BOTTOM:Landroid/graphics/drawable/GradientDrawable$Orientation;

    .line 421
    const/4 v2, -0x1

    const v3, 0x3d75c28f    # 0.06f

    invoke-static {p0, v2, v3}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->blend(IIF)I

    move-result v2

    filled-new-array {v2, p0}, [I

    move-result-object p0

    invoke-direct {v0, v1, p0}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    .line 422
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object p0

    const/16 v1, 0xc

    invoke-static {p0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result p0

    int-to-float p0, p0

    invoke-virtual {v0, p0}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 423
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object p0

    const/4 v1, 0x1

    invoke-static {p0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result p0

    invoke-static {v1, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    const/16 v1, 0x9

    invoke-static {v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v1

    const/16 v2, 0x66

    invoke-static {v1, v2}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->alpha(II)I

    move-result v1

    invoke-virtual {v0, p0, v1}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    .line 424
    return-object v0
.end method

.method public static buttonState(Ljava/lang/String;)Landroid/graphics/drawable/Drawable;
    .locals 8

    .line 429
    :try_start_0
    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->button(Ljava/lang/String;)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v0

    .line 430
    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->panelButtonColor(Ljava/lang/String;)I

    move-result v1

    .line 431
    new-instance v2, Landroid/graphics/drawable/GradientDrawable;

    sget-object v3, Landroid/graphics/drawable/GradientDrawable$Orientation;->TOP_BOTTOM:Landroid/graphics/drawable/GradientDrawable$Orientation;

    const/4 v4, 0x2

    new-array v4, v4, [I

    .line 433
    const/16 v5, 0x9

    invoke-static {v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v6

    const v7, 0x3ec28f5c    # 0.38f

    invoke-static {v1, v6, v7}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->blend(IIF)I

    move-result v6

    const/4 v7, 0x0

    aput v6, v4, v7

    .line 434
    invoke-static {v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v6

    const v7, 0x3e4ccccd    # 0.2f

    invoke-static {v1, v6, v7}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->blend(IIF)I

    move-result v1

    const/4 v6, 0x1

    aput v1, v4, v6

    invoke-direct {v2, v3, v4}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    .line 435
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object v1

    const/16 v3, 0xc

    invoke-static {v1, v3}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {v2, v1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 436
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1, v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v1

    invoke-static {v6, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    invoke-static {v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v3

    invoke-virtual {v2, v1, v3}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    .line 437
    nop

    .line 438
    new-instance v1, Landroid/graphics/drawable/RippleDrawable;

    invoke-static {v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v2

    const/16 v3, 0x55

    invoke-static {v2, v3}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->alpha(II)I

    move-result v2

    invoke-static {v2}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v2

    const/4 v3, 0x0

    invoke-direct {v1, v2, v0, v3}, Landroid/graphics/drawable/RippleDrawable;-><init>(Landroid/content/res/ColorStateList;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object v1

    .line 445
    :catchall_0
    move-exception v0

    .line 446
    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->button(Ljava/lang/String;)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p0

    return-object p0
.end method

.method public static card(II)Landroid/graphics/drawable/GradientDrawable;
    .locals 2

    .line 409
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 410
    invoke-virtual {v0, p0}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    .line 411
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object p0

    const/16 v1, 0x10

    invoke-static {p0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result p0

    int-to-float p0, p0

    invoke-virtual {v0, p0}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 412
    if-eqz p1, :cond_0

    .line 413
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object p0

    const/4 v1, 0x1

    invoke-static {p0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result p0

    invoke-static {v1, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    invoke-virtual {v0, p0, p1}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    .line 415
    :cond_0
    return-object v0
.end method

.method private static clamp(I)I
    .locals 1

    .line 371
    if-gez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    const/16 v0, 0xff

    if-le p0, v0, :cond_1

    const/16 p0, 0xff

    :cond_1
    :goto_0
    return p0
.end method

.method public static color(I)I
    .locals 1

    # The routed call sites in main cannot pass the slot in a register: every
    # register there already holds a live value from the original code and
    # writing to one corrupts unrelated drawing state.  They leave the slot in
    # main->_paletteSlot instead and call this with no arguments; the argument
    # form is kept for the direct callers in this file.
    .line 305
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->loadPrefs()V

    .line 306
    if-ltz p0, :cond_1

    const/16 v0, 0x11

    if-lt p0, v0, :cond_0

    goto :goto_0

    .line 309
    :cond_0
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->current:[I

    aget p0, v0, p0

    return p0

    .line 307
    :cond_1
    :goto_0
    const/high16 p0, -0x1000000

    return p0
.end method

.method public static color()I
    .locals 1

    # argument-less variant: read the slot the routined call sites staged
    .line 316
    sget v0, Lcom/developeramira/remotemediastar/main;->_paletteSlot:I

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    return v0
.end method

.method public static count()I
    .locals 1

    .line 273
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_IDS:[Ljava/lang/String;

    array-length v0, v0

    return v0
.end method

.method private static ctx()Landroid/content/Context;
    .locals 1

    .line 149
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->activity()Landroid/app/Activity;

    move-result-object v0

    .line 150
    if-eqz v0, :cond_0

    .line 151
    return-object v0

    .line 154
    :cond_0
    :try_start_0
    sget-object v0, Lcom/developeramira/remotemediastar/main;->mostCurrent:Lcom/developeramira/remotemediastar/main;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object v0

    .line 155
    :catchall_0
    move-exception v0

    .line 156
    const/4 v0, 0x0

    return-object v0
.end method

.method public static dp(Landroid/content/Context;I)I
    .locals 1

    .line 379
    if-nez p0, :cond_0

    .line 380
    return p1

    .line 383
    :cond_0
    int-to-float v0, p1

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    mul-float v0, v0, p0

    const/high16 p0, 0x3f000000    # 0.5f

    add-float/2addr v0, p0

    float-to-int p0, v0

    return p0

    .line 384
    :catchall_0
    move-exception p0

    .line 385
    return p1
.end method

.method public static getEffect()I
    .locals 1

    .line 578
    sget v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->effect:I

    return v0
.end method

.method public static getTheme()Ljava/lang/String;
    .locals 1

    .line 212
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->loadPrefs()V

    .line 213
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->currentId:Ljava/lang/String;

    return-object v0
.end method

.method public static gradientBottom()I
    .locals 1

    .line 329
    const/4 v0, 0x2

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    return v0
.end method

.method public static gradientTop()I
    .locals 1

    .line 325
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    return v0
.end method

.method public static hideDeveloperPage()V
    .locals 5

    .line 811
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->developerOverlay:Landroid/view/View;

    .line 812
    const/4 v1, 0x0

    sput-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->developerOverlay:Landroid/view/View;

    .line 813
    if-nez v0, :cond_0

    .line 814
    return-void

    .line 816
    :cond_0
    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->animateOut(Landroid/view/View;)V

    .line 817
    sget-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->MAIN:Landroid/os/Handler;

    new-instance v2, Lcom/developeramira/remotemediastar/theme/ThemeManager$4;

    invoke-direct {v2, v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager$4;-><init>(Landroid/view/View;)V

    const-wide/16 v3, 0xbe

    invoke-virtual {v1, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 823
    return-void
.end method

.method public static hideSettingsPanel()V
    .locals 5

    .line 501
    :try_start_0
    sget-object v0, Lcom/developeramira/remotemediastar/main;->mostCurrent:Lcom/developeramira/remotemediastar/main;

    .line 503
    if-nez v0, :cond_0

    .line 504
    return-void

    .line 506
    :cond_0
    iget-object v0, v0, Lcom/developeramira/remotemediastar/main;->_vvv1:Lanywheresoftware/b4a/objects/PanelWrapper;

    .line 507
    if-eqz v0, :cond_3

    invoke-virtual {v0}, Lanywheresoftware/b4a/objects/PanelWrapper;->IsInitialized()Z

    move-result v1

    if-nez v1, :cond_1

    goto :goto_0

    .line 510
    :cond_1
    invoke-static {v0}, Lanywheresoftware/b4a/AbsObjectWrapper;->getObject(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 511
    instance-of v2, v1, Landroid/view/View;

    if-eqz v2, :cond_2

    .line 512
    check-cast v1, Landroid/view/View;

    invoke-static {v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->animateOut(Landroid/view/View;)V

    .line 514
    :cond_2
    sget-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->MAIN:Landroid/os/Handler;

    new-instance v2, Lcom/developeramira/remotemediastar/theme/ThemeManager$1;

    invoke-direct {v2, v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager$1;-><init>(Lanywheresoftware/b4a/objects/PanelWrapper;)V

    const-wide/16 v3, 0xaf

    invoke-virtual {v1, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 524
    goto :goto_1

    .line 508
    :cond_3
    :goto_0
    return-void

    .line 523
    :catchall_0
    move-exception v0

    .line 525
    :goto_1
    return-void
.end method

.method public static hideThemeChooser()V
    .locals 5

    .line 1093
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->themeOverlay:Landroid/view/View;

    .line 1094
    const/4 v1, 0x0

    sput-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->themeOverlay:Landroid/view/View;

    .line 1095
    if-nez v0, :cond_0

    .line 1096
    return-void

    .line 1098
    :cond_0
    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->animateOut(Landroid/view/View;)V

    .line 1099
    sget-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->MAIN:Landroid/os/Handler;

    new-instance v2, Lcom/developeramira/remotemediastar/theme/ThemeManager$7;

    invoke-direct {v2, v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager$7;-><init>(Landroid/view/View;)V

    const-wide/16 v3, 0xbe

    invoke-virtual {v1, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1105
    return-void
.end method

.method public static indexOf(Ljava/lang/String;)I
    .locals 5

    .line 254
    const/4 v0, -0x1

    if-nez p0, :cond_0

    .line 255
    return v0

    .line 257
    :cond_0
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    .line 258
    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_0
    sget-object v3, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_IDS:[Ljava/lang/String;

    array-length v4, v3

    if-ge v2, v4, :cond_2

    .line 259
    aget-object v3, v3, v2

    invoke-virtual {v3, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 260
    return v2

    .line 258
    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 263
    :cond_2
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_3

    const-string v2, "dark"

    invoke-virtual {v2, p0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_3

    .line 264
    const/4 p0, 0x1

    return p0

    .line 266
    :cond_3
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_4

    const-string v2, "light"

    invoke-virtual {v2, p0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_4

    .line 267
    return v1

    .line 269
    :cond_4
    return v0
.end method

.method public static install()V
    .locals 1

    .line 1052
    :try_start_0
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->loadPrefs()V

    .line 1053
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->syncLegacyFlag()V

    .line 1054
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->activity()Landroid/app/Activity;

    move-result-object v0

    .line 1055
    if-eqz v0, :cond_0

    .line 1056
    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->applyToWindow(Landroid/app/Activity;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1059
    :cond_0
    goto :goto_0

    .line 1058
    :catchall_0
    move-exception v0

    .line 1060
    :goto_0
    return-void
.end method

.method public static isDark()Z
    .locals 2

    .line 296
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->loadPrefs()V

    .line 297
    const-string v0, "light"

    sget-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->currentId:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    return v0
.end method

.method public static loadPrefs()V
    .locals 4

    .line 178
    sget-boolean v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->loaded:Z

    if-eqz v0, :cond_0

    .line 179
    return-void

    .line 181
    :cond_0
    const/4 v0, 0x1

    sput-boolean v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->loaded:Z

    .line 182
    nop

    .line 183
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->prefs()Landroid/content/SharedPreferences;

    move-result-object v0

    .line 184
    if-eqz v0, :cond_1

    .line 185
    const-string v1, "theme_id"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->indexOf(Ljava/lang/String;)I

    move-result v0

    goto :goto_0

    .line 184
    :cond_1
    const/4 v0, -0x1

    .line 187
    :goto_0
    if-gez v0, :cond_3

    .line 188
    nop

    .line 190
    const/4 v0, 0x0

    :try_start_0
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object v1

    .line 191
    if-eqz v1, :cond_2

    .line 192
    new-instance v2, Ljava/io/File;

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v3, "theme.txt"

    invoke-direct {v2, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 193
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 194
    new-instance v1, Ljava/io/BufferedReader;

    new-instance v3, Ljava/io/FileReader;

    invoke-direct {v3, v2}, Ljava/io/FileReader;-><init>(Ljava/io/File;)V

    invoke-direct {v1, v3}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 196
    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v2

    .line 197
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V

    .line 198
    invoke-static {v2}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->indexOf(Ljava/lang/String;)I

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 199
    if-ltz v1, :cond_2

    .line 200
    move v0, v1

    .line 205
    :cond_2
    goto :goto_1

    .line 204
    :catchall_0
    move-exception v1

    .line 207
    :cond_3
    :goto_1
    sget-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_IDS:[Ljava/lang/String;

    aget-object v1, v1, v0

    sput-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->currentId:Ljava/lang/String;

    .line 208
    sget-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->PALETTES:[[I

    aget-object v0, v1, v0

    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->current:[I

    .line 209
    return-void
.end method

.method public static openGithub()V
    .locals 2

    .line 1046
    const-string v0, "https://github.com/developeramira"

    const-string v1, "developeramira"

    invoke-static {v0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->openLink(Ljava/lang/String;Ljava/lang/String;)Z

    .line 1047
    return-void
.end method

# Direct OnClickListener for the "developer page" entry in the settings panel.
# The generated b4a code normally attaches callbacks through
# main._v5.RunMethod("<Sub>", ...), which resolves the name reflectively at
# runtime - a build cannot prove the target exists, and this button's callback
# was in fact never reachable.  A plain listener is verifiable and does not
# depend on b4a's reflective plumbing.
.method public static attachDeveloperButton(Landroid/view/View;)V
    .locals 1

    if-eqz p0, :cond_0

    new-instance v0, Lcom/developeramira/remotemediastar/theme/ThemeManager$11;

    invoke-direct {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager$11;-><init>()V

    invoke-virtual {p0, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    :cond_0
    return-void
.end method

.method public static openInstagram()V
    .locals 2

    .line 1038
    const-string v0, "https://instagram.com/x.amirrezaa1"

    const-string v1, "x.amirrezaa1"

    invoke-static {v0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->openLink(Ljava/lang/String;Ljava/lang/String;)Z

    .line 1039
    return-void
.end method

.method public static openLink(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 3

    .line 1015
    const/4 v0, 0x0

    :try_start_0
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.VIEW"

    invoke-static {p0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0

    invoke-direct {v1, v2, p0}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 1016
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->activity()Landroid/app/Activity;

    move-result-object p0

    .line 1017
    if-eqz p0, :cond_0

    .line 1018
    invoke-virtual {p0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    goto :goto_0

    .line 1020
    :cond_0
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object p0

    .line 1021
    if-nez p0, :cond_1

    .line 1022
    return v0

    .line 1024
    :cond_1
    const/high16 v2, 0x10000000

    invoke-virtual {v1, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 1025
    invoke-virtual {p0, v1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    .line 1027
    :goto_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u062f\u0631 \u062d\u0627\u0644 \u0628\u0627\u0632 \u06a9\u0631\u062f\u0646 "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->toast(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1029
    const/4 p0, 0x1

    return p0

    .line 1030
    :catchall_0
    move-exception p0

    .line 1031
    const-string p0, "\u0627\u0645\u06a9\u0627\u0646 \u0628\u0627\u0632 \u06a9\u0631\u062f\u0646 \u0644\u06cc\u0646\u06a9 \u0648\u062c\u0648\u062f \u0646\u062f\u0627\u0631\u062f"

    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->toast(Ljava/lang/String;)V

    .line 1033
    return v0
.end method

.method public static openTelegram()V
    .locals 2

    .line 1042
    const-string v0, "https://t.me/developer_as"

    const-string v1, "developer_as"

    invoke-static {v0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->openLink(Ljava/lang/String;Ljava/lang/String;)Z

    .line 1043
    return-void
.end method

.method public static pageBackground()I
    .locals 1

    .line 333
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    return v0
.end method

.method public static pageGradient()Landroid/graphics/drawable/GradientDrawable;
    .locals 2

    .line 401
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    const/4 v1, 0x2

    invoke-static {v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v1

    invoke-static {v0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->vertical(II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v0

    return-object v0
.end method

.method public static panelBottom()I
    .locals 1

    .line 341
    const/4 v0, 0x4

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    return v0
.end method

.method public static panelButtonColor(Ljava/lang/String;)I
    .locals 3

    .line 346
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->loadPrefs()V

    .line 347
    const/4 v0, 0x7

    if-nez p0, :cond_0

    .line 348
    sget-object p0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->current:[I

    aget p0, p0, v0

    return p0

    .line 350
    :cond_0
    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    .line 351
    const-string v1, "close"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    const/4 v2, 0x1

    if-nez v1, :cond_5

    const-string v1, "back"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1

    goto :goto_1

    .line 354
    :cond_1
    const-string v1, "theme"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 355
    sget-object p0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->current:[I

    aget v0, p0, v2

    const/16 v1, 0x9

    aget p0, p0, v1

    const v1, 0x3e851eb8    # 0.26f

    invoke-static {v0, p0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->blend(IIF)I

    move-result p0

    return p0

    .line 357
    :cond_2
    const-string v1, "developer"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_4

    const-string v1, "about"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_4

    const-string v1, "dev"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_3

    goto :goto_0

    .line 360
    :cond_3
    sget-object p0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->current:[I

    aget p0, p0, v0

    return p0

    .line 358
    :cond_4
    :goto_0
    sget-object p0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->current:[I

    aget v0, p0, v2

    const/16 v1, 0xa

    aget p0, p0, v1

    const v1, 0x3e75c28f    # 0.24f

    invoke-static {v0, p0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->blend(IIF)I

    move-result p0

    return p0

    .line 352
    :cond_5
    :goto_1
    sget-object p0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->current:[I

    aget v0, p0, v2

    const/16 v1, 0xf

    aget p0, p0, v1

    const v1, 0x3e4ccccd    # 0.2f

    invoke-static {v0, p0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->blend(IIF)I

    move-result p0

    return p0
.end method

.method public static panelGradient()Landroid/graphics/drawable/GradientDrawable;
    .locals 2

    .line 405
    const/4 v0, 0x3

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    const/4 v1, 0x4

    invoke-static {v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v1

    invoke-static {v0, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->vertical(II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v0

    return-object v0
.end method

.method public static panelTop()I
    .locals 1

    .line 337
    const/4 v0, 0x3

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    return v0
.end method

.method private static prefs()Landroid/content/SharedPreferences;
    .locals 4

    .line 161
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object v0

    .line 162
    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 163
    return-object v1

    .line 166
    :cond_0
    :try_start_0
    const-string v2, "mediastar_theme_prefs"

    const/4 v3, 0x0

    invoke-virtual {v0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object v0

    .line 167
    :catchall_0
    move-exception v0

    .line 168
    return-object v1
.end method

.method public static pulse(Landroid/view/View;)V
    .locals 10

    .line 723
    if-nez p0, :cond_0

    .line 724
    return-void

    .line 727
    :cond_0
    :try_start_0
    new-instance v9, Landroid/view/animation/ScaleAnimation;

    const/high16 v1, 0x3f800000    # 1.0f

    const v2, 0x3f87ae14    # 1.06f

    const/high16 v3, 0x3f800000    # 1.0f

    const v4, 0x3f87ae14    # 1.06f

    const/4 v5, 0x1

    const/high16 v6, 0x3f000000    # 0.5f

    const/4 v7, 0x1

    const/high16 v8, 0x3f000000    # 0.5f

    move-object v0, v9

    invoke-direct/range {v0 .. v8}, Landroid/view/animation/ScaleAnimation;-><init>(FFFFIFIF)V

    .line 730
    const-wide/16 v0, 0x78

    invoke-virtual {v9, v0, v1}, Landroid/view/animation/ScaleAnimation;->setDuration(J)V

    .line 731
    const/4 v0, 0x2

    invoke-virtual {v9, v0}, Landroid/view/animation/ScaleAnimation;->setRepeatMode(I)V

    .line 732
    const/4 v0, 0x1

    invoke-virtual {v9, v0}, Landroid/view/animation/ScaleAnimation;->setRepeatCount(I)V

    .line 733
    invoke-virtual {p0, v9}, Landroid/view/View;->startAnimation(Landroid/view/animation/Animation;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 735
    goto :goto_0

    .line 734
    :catchall_0
    move-exception p0

    .line 736
    :goto_0
    return-void
.end method

.method private static remove(Landroid/view/View;)V
    .locals 2

    .line 549
    if-nez p0, :cond_0

    .line 550
    return-void

    .line 552
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 553
    instance-of v1, v0, Landroid/view/ViewGroup;

    if-eqz v1, :cond_1

    .line 554
    check-cast v0, Landroid/view/ViewGroup;

    invoke-virtual {v0, p0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 557
    :cond_1
    goto :goto_0

    .line 556
    :catchall_0
    move-exception p0

    .line 558
    :goto_0
    return-void
.end method

.method private static safe(I)I
    .locals 1

    .line 289
    if-ltz p0, :cond_1

    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_IDS:[Ljava/lang/String;

    array-length v0, v0

    if-lt p0, v0, :cond_0

    goto :goto_0

    .line 292
    :cond_0
    return p0

    .line 290
    :cond_1
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method public static setEffect(I)V
    .locals 0

    .line 574
    rem-int/lit8 p0, p0, 0x5

    add-int/lit8 p0, p0, 0x5

    rem-int/lit8 p0, p0, 0x5

    sput p0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->effect:I

    .line 575
    return-void
.end method

.method public static setTheme(Ljava/lang/String;)V
    .locals 2

    .line 217
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->loadPrefs()V

    .line 218
    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->indexOf(Ljava/lang/String;)I

    move-result p0

    .line 219
    if-gez p0, :cond_0

    .line 220
    const/4 p0, 0x0

    .line 222
    :cond_0
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_IDS:[Ljava/lang/String;

    aget-object v0, v0, p0

    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->currentId:Ljava/lang/String;

    .line 223
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->PALETTES:[[I

    aget-object p0, v0, p0

    sput-object p0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->current:[I

    .line 224
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->prefs()Landroid/content/SharedPreferences;

    move-result-object p0

    .line 225
    if-eqz p0, :cond_1

    .line 227
    :try_start_0
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "theme_id"

    sget-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->currentId:Ljava/lang/String;

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 229
    goto :goto_0

    .line 228
    :catchall_0
    move-exception p0

    .line 231
    :cond_1
    :goto_0
    return-void
.end method

.method public static setThemeIndex(I)V
    .locals 1

    .line 235
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_IDS:[Ljava/lang/String;

    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->safe(I)I

    move-result p0

    aget-object p0, v0, p0

    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->setTheme(Ljava/lang/String;)V

    .line 236
    return-void
.end method

.method public static showDeveloperPage()V
    .locals 4

    .line 788
    :try_start_0
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->activity()Landroid/app/Activity;

    move-result-object v0

    .line 789
    if-nez v0, :cond_0

    .line 790
    return-void

    .line 792
    :cond_0
    sget-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->developerOverlay:Landroid/view/View;

    invoke-static {v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->remove(Landroid/view/View;)V

    .line 793
    const/4 v1, 0x0

    sput-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->developerOverlay:Landroid/view/View;

    .line 794
    const v1, 0x1020002

    invoke-virtual {v0, v1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    .line 795
    instance-of v2, v1, Landroid/view/ViewGroup;

    if-nez v2, :cond_1

    .line 796
    return-void

    .line 798
    :cond_1
    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->buildDeveloperOverlay(Landroid/app/Activity;)Landroid/widget/FrameLayout;

    move-result-object v0

    .line 799
    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->developerOverlay:Landroid/view/View;

    .line 800
    check-cast v1, Landroid/view/ViewGroup;

    new-instance v2, Landroid/view/ViewGroup$LayoutParams;

    const/4 v3, -0x1

    invoke-direct {v2, v3, v3}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v0, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 803
    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->animateIn(Landroid/view/View;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 807
    goto :goto_0

    .line 804
    :catchall_0
    move-exception v0

    .line 805
    const-string v0, "\u062e\u0637\u0627 \u062f\u0631 \u0628\u0627\u0632 \u06a9\u0631\u062f\u0646 \u0635\u0641\u062d\u0647 \u062a\u0648\u0633\u0639\u0647\u200c\u062f\u0647\u0646\u062f\u0647"

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->toast(Ljava/lang/String;)V

    .line 808
    :goto_0
    return-void
.end method

.method public static showSettingsPanelIn()V
    .locals 2

    .line 530
    :try_start_0
    sget-object v0, Lcom/developeramira/remotemediastar/main;->mostCurrent:Lcom/developeramira/remotemediastar/main;

    .line 532
    if-nez v0, :cond_0

    .line 533
    return-void

    .line 535
    :cond_0
    iget-object v0, v0, Lcom/developeramira/remotemediastar/main;->_vvv1:Lanywheresoftware/b4a/objects/PanelWrapper;

    .line 536
    if-eqz v0, :cond_3

    invoke-virtual {v0}, Lanywheresoftware/b4a/objects/PanelWrapper;->IsInitialized()Z

    move-result v1

    if-nez v1, :cond_1

    goto :goto_0

    .line 539
    :cond_1
    invoke-static {v0}, Lanywheresoftware/b4a/AbsObjectWrapper;->getObject(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 540
    instance-of v1, v0, Landroid/view/View;

    if-eqz v1, :cond_2

    .line 541
    check-cast v0, Landroid/view/View;

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->animateIn(Landroid/view/View;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 544
    :cond_2
    goto :goto_1

    .line 537
    :cond_3
    :goto_0
    return-void

    .line 543
    :catchall_0
    move-exception v0

    .line 545
    :goto_1
    return-void
.end method

.method public static showThemeChooser()V
    .locals 4

    .line 1070
    :try_start_0
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->activity()Landroid/app/Activity;

    move-result-object v0

    .line 1071
    if-nez v0, :cond_0

    .line 1072
    return-void

    .line 1074
    :cond_0
    sget-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->themeOverlay:Landroid/view/View;

    invoke-static {v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->remove(Landroid/view/View;)V

    .line 1075
    const/4 v1, 0x0

    sput-object v1, Lcom/developeramira/remotemediastar/theme/ThemeManager;->themeOverlay:Landroid/view/View;

    .line 1076
    const v1, 0x1020002

    invoke-virtual {v0, v1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    .line 1077
    instance-of v2, v1, Landroid/view/ViewGroup;

    if-nez v2, :cond_1

    .line 1078
    return-void

    .line 1080
    :cond_1
    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->buildThemeOverlay(Landroid/app/Activity;)Landroid/widget/FrameLayout;

    move-result-object v0

    .line 1081
    sput-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->themeOverlay:Landroid/view/View;

    .line 1082
    check-cast v1, Landroid/view/ViewGroup;

    new-instance v2, Landroid/view/ViewGroup$LayoutParams;

    const/4 v3, -0x1

    invoke-direct {v2, v3, v3}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v0, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1085
    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->animateIn(Landroid/view/View;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1089
    goto :goto_0

    .line 1086
    :catchall_0
    move-exception v0

    .line 1087
    const-string v0, "\u062e\u0637\u0627 \u062f\u0631 \u0628\u0627\u0632 \u06a9\u0631\u062f\u0646 \u0627\u0646\u062a\u062e\u0627\u0628 \u062a\u0645"

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->toast(Ljava/lang/String;)V

    .line 1090
    :goto_0
    return-void
.end method

.method private static socialRow(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/view/View;
    .locals 9

    .line 953
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 954
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 955
    const/16 v2, 0x10

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 956
    new-instance v2, Landroid/graphics/drawable/GradientDrawable;

    sget-object v3, Landroid/graphics/drawable/GradientDrawable$Orientation;->LEFT_RIGHT:Landroid/graphics/drawable/GradientDrawable$Orientation;

    .line 957
    const/4 v4, 0x5

    invoke-static {v4}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v4

    const/4 v5, 0x6

    invoke-static {v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v5

    filled-new-array {v4, v5}, [I

    move-result-object v4

    invoke-direct {v2, v3, v4}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    .line 958
    const/16 v3, 0xe

    invoke-static {p0, v3}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v2, v4}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 959
    const/4 v4, 0x1

    invoke-static {p0, v4}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v5

    invoke-static {v4, v5}, Ljava/lang/Math;->max(II)I

    move-result v5

    const/16 v6, 0x9

    invoke-static {v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v7

    const/16 v8, 0x66

    invoke-static {v7, v8}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->alpha(II)I

    move-result v7

    invoke-virtual {v2, v5, v7}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    .line 960
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 961
    invoke-static {p0, v3}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v2

    .line 962
    invoke-virtual {v0, v2, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 963
    invoke-virtual {v0, v4}, Landroid/widget/LinearLayout;->setClickable(Z)V

    .line 964
    new-instance v2, Lcom/developeramira/remotemediastar/theme/ThemeManager$6;

    invoke-direct {v2, p4, p3}, Lcom/developeramira/remotemediastar/theme/ThemeManager$6;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 972
    new-instance p4, Landroid/widget/TextView;

    invoke-direct {p4, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 973
    invoke-virtual {p4, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 974
    const/high16 p1, 0x41a00000    # 20.0f

    invoke-virtual {p4, p1}, Landroid/widget/TextView;->setTextSize(F)V

    .line 975
    const/16 p1, 0x11

    invoke-virtual {p4, p1}, Landroid/widget/TextView;->setGravity(I)V

    .line 976
    new-instance p1, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v2, 0x24

    invoke-static {p0, v2}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-static {p0, v2}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-direct {p1, v3, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 977
    const/16 v2, 0xc

    invoke-static {p0, v2}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {p1, v1, v1, v3, v1}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V

    .line 978
    invoke-virtual {v0, p4, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 980
    new-instance p1, Landroid/widget/LinearLayout;

    invoke-direct {p1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 981
    invoke-virtual {p1, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 983
    new-instance p4, Landroid/widget/TextView;

    invoke-direct {p4, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 984
    invoke-virtual {p4, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 985
    invoke-static {v2}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result p2

    invoke-virtual {p4, p2}, Landroid/widget/TextView;->setTextColor(I)V

    .line 986
    const/high16 p2, 0x41600000    # 14.0f

    invoke-virtual {p4, p2}, Landroid/widget/TextView;->setTextSize(F)V

    .line 987
    sget-object p2, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {p4, p2}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 988
    invoke-virtual {p1, p4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 990
    new-instance p2, Landroid/widget/TextView;

    invoke-direct {p2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 991
    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 992
    invoke-static {v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result p3

    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setTextColor(I)V

    .line 993
    const/high16 p3, 0x41400000    # 12.0f

    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setTextSize(F)V

    .line 994
    invoke-virtual {p1, p2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 996
    new-instance p2, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 p3, 0x3f800000    # 1.0f

    const/4 p4, -0x2

    invoke-direct {p2, v1, p4, p3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v0, p1, p2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 999
    new-instance p1, Landroid/widget/TextView;

    invoke-direct {p1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 1000
    const-string p2, "\u2190"

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1001
    invoke-static {v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTextColor(I)V

    .line 1002
    const/high16 p2, 0x41900000    # 18.0f

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setTextSize(F)V

    .line 1003
    invoke-virtual {v0, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1005
    new-instance p1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 p2, -0x1

    invoke-direct {p1, p2, p4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 1007
    const/16 p2, 0xa

    invoke-static {p0, p2}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result p0

    iput p0, p1, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    .line 1008
    invoke-virtual {v0, p1}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1009
    return-object v0
.end method

.method public static syncLegacyFlag()V
    .locals 4

    .line 241
    :try_start_0
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->isDark()Z

    move-result v0

    sput-boolean v0, Lcom/developeramira/remotemediastar/main;->_vv1:Z

    .line 242
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->ctx()Landroid/content/Context;

    move-result-object v0

    .line 243
    if-eqz v0, :cond_1

    .line 244
    new-instance v1, Ljava/io/FileWriter;

    new-instance v2, Ljava/io/File;

    .line 245
    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v0

    const-string v3, "theme.txt"

    invoke-direct {v2, v0, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-direct {v1, v2}, Ljava/io/FileWriter;-><init>(Ljava/io/File;)V

    .line 246
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->isDark()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "dark"

    goto :goto_0

    :cond_0
    const-string v0, "light"

    :goto_0
    invoke-virtual {v1, v0}, Ljava/io/FileWriter;->write(Ljava/lang/String;)V

    .line 247
    invoke-virtual {v1}, Ljava/io/FileWriter;->close()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 250
    :cond_1
    goto :goto_1

    .line 249
    :catchall_0
    move-exception v0

    .line 251
    :goto_1
    return-void
.end method

.method public static textColor()I
    .locals 1

    .line 321
    const/16 v0, 0xc

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->color(I)I

    move-result v0

    return v0
.end method

.method private static themeCard(Landroid/app/Activity;IZ)Landroid/view/View;
    .locals 16

    .line 1177
    move-object/from16 v0, p0

    move/from16 v1, p1

    sget-object v2, Lcom/developeramira/remotemediastar/theme/ThemeManager;->PALETTES:[[I

    aget-object v2, v2, v1

    .line 1178
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 1179
    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 1180
    const/16 v5, 0x10

    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 1181
    new-instance v6, Landroid/graphics/drawable/GradientDrawable;

    sget-object v7, Landroid/graphics/drawable/GradientDrawable$Orientation;->LEFT_RIGHT:Landroid/graphics/drawable/GradientDrawable$Orientation;

    const/4 v8, 0x7

    aget v8, v2, v8

    const/4 v9, 0x5

    aget v9, v2, v9

    filled-new-array {v8, v9}, [I

    move-result-object v8

    invoke-direct {v6, v7, v8}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    .line 1183
    invoke-static {v0, v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v5

    int-to-float v5, v5

    invoke-virtual {v6, v5}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    .line 1184
    const/4 v5, 0x1

    if-eqz p2, :cond_0

    const/4 v7, 0x2

    goto :goto_0

    :cond_0
    const/4 v7, 0x1

    :goto_0
    invoke-static {v0, v7}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v7

    invoke-static {v5, v7}, Ljava/lang/Math;->max(II)I

    move-result v7

    const/16 v8, 0x8

    const/16 v9, 0x9

    if-eqz p2, :cond_1

    aget v10, v2, v9

    goto :goto_1

    :cond_1
    aget v10, v2, v8

    .line 1185
    const/16 v11, 0xaa

    invoke-static {v10, v11}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->alpha(II)I

    move-result v10

    .line 1184
    :goto_1
    invoke-virtual {v6, v7, v10}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    .line 1186
    invoke-virtual {v3, v6}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 1187
    const/16 v6, 0xc

    invoke-static {v0, v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v7

    .line 1188
    invoke-virtual {v3, v7, v7, v7, v7}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 1190
    new-instance v7, Landroid/widget/LinearLayout;

    invoke-direct {v7, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 1191
    invoke-virtual {v7, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 1192
    aget v10, v2, v4

    aget v11, v2, v9

    const/16 v12, 0xa

    aget v13, v2, v12

    filled-new-array {v10, v11, v13}, [I

    move-result-object v10

    .line 1193
    const/4 v11, 0x0

    :goto_2
    const/4 v13, -0x1

    const/4 v14, 0x3

    if-ge v11, v14, :cond_2

    aget v14, v10, v11

    .line 1194
    new-instance v15, Landroid/view/View;

    invoke-direct {v15, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 1195
    new-instance v12, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v12}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 1196
    invoke-virtual {v12, v5}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    .line 1197
    invoke-virtual {v12, v14}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    .line 1198
    invoke-static {v0, v5}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v14

    invoke-static {v5, v14}, Ljava/lang/Math;->max(II)I

    move-result v14

    const/16 v9, 0x66

    invoke-static {v13, v9}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->alpha(II)I

    move-result v9

    invoke-virtual {v12, v14, v9}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    .line 1199
    invoke-virtual {v15, v12}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 1200
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v12, 0x18

    invoke-static {v0, v12}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v13

    invoke-static {v0, v12}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v12

    invoke-direct {v9, v13, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 1201
    const/4 v12, 0x4

    invoke-static {v0, v12}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v12

    invoke-virtual {v9, v4, v4, v12, v4}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V

    .line 1202
    invoke-virtual {v7, v15, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1193
    add-int/lit8 v11, v11, 0x1

    const/16 v9, 0x9

    const/16 v12, 0xa

    goto :goto_2

    .line 1204
    :cond_2
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v10, -0x2

    invoke-direct {v9, v10, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v3, v7, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1207
    new-instance v7, Landroid/widget/LinearLayout;

    invoke-direct {v7, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 1208
    invoke-virtual {v7, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 1209
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v11, 0x3f800000    # 1.0f

    invoke-direct {v9, v4, v10, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    .line 1211
    invoke-static {v0, v6}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v11

    invoke-static {v0, v8}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v8

    invoke-virtual {v9, v11, v4, v8, v4}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V

    .line 1213
    new-instance v4, Landroid/widget/TextView;

    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 1214
    sget-object v8, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_NAMES:[Ljava/lang/String;

    aget-object v8, v8, v1

    invoke-virtual {v4, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1215
    aget v6, v2, v6

    invoke-virtual {v4, v6}, Landroid/widget/TextView;->setTextColor(I)V

    .line 1216
    const/high16 v6, 0x41600000    # 14.0f

    invoke-virtual {v4, v6}, Landroid/widget/TextView;->setTextSize(F)V

    .line 1217
    sget-object v6, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v4, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 1218
    invoke-virtual {v7, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1220
    new-instance v4, Landroid/widget/TextView;

    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 1221
    sget-object v6, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_TAGS:[Ljava/lang/String;

    aget-object v6, v6, v1

    invoke-virtual {v4, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1222
    const/16 v6, 0xd

    aget v8, v2, v6

    invoke-virtual {v4, v8}, Landroid/widget/TextView;->setTextColor(I)V

    .line 1223
    const/high16 v8, 0x41300000    # 11.0f

    invoke-virtual {v4, v8}, Landroid/widget/TextView;->setTextSize(F)V

    .line 1224
    invoke-virtual {v7, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1225
    invoke-virtual {v3, v7, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1227
    new-instance v4, Landroid/widget/TextView;

    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 1228
    if-eqz p2, :cond_3

    const-string v7, "\u2714"

    goto :goto_3

    :cond_3
    const-string v7, "\u25cb"

    :goto_3
    invoke-virtual {v4, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1229
    if-eqz p2, :cond_4

    const/16 v6, 0x9

    aget v2, v2, v6

    goto :goto_4

    :cond_4
    aget v2, v2, v6

    :goto_4
    invoke-virtual {v4, v2}, Landroid/widget/TextView;->setTextColor(I)V

    .line 1230
    const/high16 v2, 0x41900000    # 18.0f

    invoke-virtual {v4, v2}, Landroid/widget/TextView;->setTextSize(F)V

    .line 1231
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1233
    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->setClickable(Z)V

    .line 1234
    new-instance v2, Lcom/developeramira/remotemediastar/theme/ThemeManager$9;

    invoke-direct {v2, v1}, Lcom/developeramira/remotemediastar/theme/ThemeManager$9;-><init>(I)V

    invoke-virtual {v3, v2}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 1252
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v1, v13, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 1254
    const/16 v2, 0xa

    invoke-static {v0, v2}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->dp(Landroid/content/Context;I)I

    move-result v0

    iput v0, v1, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    .line 1255
    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1256
    return-object v3
.end method

.method public static themeId(I)Ljava/lang/String;
    .locals 1

    .line 277
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_IDS:[Ljava/lang/String;

    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->safe(I)I

    move-result p0

    aget-object p0, v0, p0

    return-object p0
.end method

.method public static themeName(I)Ljava/lang/String;
    .locals 1

    .line 281
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_NAMES:[Ljava/lang/String;

    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->safe(I)I

    move-result p0

    aget-object p0, v0, p0

    return-object p0
.end method

.method public static themeTag(I)Ljava/lang/String;
    .locals 1

    .line 285
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_TAGS:[Ljava/lang/String;

    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->safe(I)I

    move-result p0

    aget-object p0, v0, p0

    return-object p0
.end method

.method public static toast(Ljava/lang/String;)V
    .locals 2

    .line 1265
    :try_start_0
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/developeramira/remotemediastar/theme/ThemeManager$10;

    invoke-direct {v1, p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager$10;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1278
    goto :goto_0

    .line 1277
    :catchall_0
    move-exception p0

    .line 1279
    :goto_0
    return-void
.end method

.method public static transitionTo(Landroid/view/View;Landroid/view/View;)V
    .locals 0

    .line 718
    invoke-static {p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->animateOut(Landroid/view/View;)V

    .line 719
    invoke-static {p1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->animateIn(Landroid/view/View;)V

    .line 720
    return-void
.end method

.method public static vertical(II)Landroid/graphics/drawable/GradientDrawable;
    .locals 2

    .line 394
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    sget-object v1, Landroid/graphics/drawable/GradientDrawable$Orientation;->TOP_BOTTOM:Landroid/graphics/drawable/GradientDrawable$Orientation;

    filled-new-array {p0, p1}, [I

    move-result-object p0

    invoke-direct {v0, v1, p0}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    .line 396
    const/4 p0, 0x1

    invoke-virtual {v0, p0}, Landroid/graphics/drawable/GradientDrawable;->setDither(Z)V

    .line 397
    return-object v0
.end method
