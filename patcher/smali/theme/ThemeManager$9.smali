.class final Lcom/developeramira/remotemediastar/theme/ThemeManager$9;
.super Ljava/lang/Object;
.source "ThemeManager.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/developeramira/remotemediastar/theme/ThemeManager;->themeCard(Landroid/app/Activity;IZ)Landroid/view/View;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$index:I


# direct methods
.method constructor <init>(I)V
    .locals 0

    .line 1234
    iput p1, p0, Lcom/developeramira/remotemediastar/theme/ThemeManager$9;->val$index:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 3

    .line 1237
    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_IDS:[Ljava/lang/String;

    iget v1, p0, Lcom/developeramira/remotemediastar/theme/ThemeManager$9;->val$index:I

    aget-object v0, v0, v1

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->setTheme(Ljava/lang/String;)V

    .line 1238
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->syncLegacyFlag()V

    .line 1239
    invoke-static {p1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->pulse(Landroid/view/View;)V

    .line 1240
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\u062a\u0645 \u00ab"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    sget-object v0, Lcom/developeramira/remotemediastar/theme/ThemeManager;->THEME_NAMES:[Ljava/lang/String;

    iget v1, p0, Lcom/developeramira/remotemediastar/theme/ThemeManager$9;->val$index:I

    aget-object v0, v0, v1

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, "\u00bb \u0627\u0639\u0645\u0627\u0644 \u0634\u062f"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->toast(Ljava/lang/String;)V

    .line 1242
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->hideThemeChooser()V

    .line 1243
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->access$100()Landroid/os/Handler;

    move-result-object p1

    new-instance v0, Lcom/developeramira/remotemediastar/theme/ThemeManager$9$1;

    invoke-direct {v0, p0}, Lcom/developeramira/remotemediastar/theme/ThemeManager$9$1;-><init>(Lcom/developeramira/remotemediastar/theme/ThemeManager$9;)V

    const-wide/16 v1, 0xb4

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1249
    return-void
.end method
