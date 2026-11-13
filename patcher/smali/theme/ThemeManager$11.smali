.class Lcom/saminsoftware/remotemediastar/theme/ThemeManager$11;
.super Ljava/lang/Object;
.source "ThemeManager.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# direct methods
.method constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    :try_start_0
    invoke-static {}, Lcom/saminsoftware/remotemediastar/theme/ThemeManager;->showDeveloperPage()V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method
