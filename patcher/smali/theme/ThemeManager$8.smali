.class final Lcom/saminsoftware/remotemediastar/theme/ThemeManager$8;
.super Ljava/lang/Object;
.source "ThemeManager.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/saminsoftware/remotemediastar/theme/ThemeManager;->buildThemeOverlay(Landroid/app/Activity;)Landroid/widget/FrameLayout;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 1159
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    .line 1162
    invoke-static {p1}, Lcom/saminsoftware/remotemediastar/theme/ThemeManager;->pulse(Landroid/view/View;)V

    .line 1163
    invoke-static {}, Lcom/saminsoftware/remotemediastar/theme/ThemeManager;->hideThemeChooser()V

    .line 1164
    return-void
.end method
