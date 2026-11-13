.class final Lcom/developeramira/remotemediastar/theme/ThemeManager$10;
.super Ljava/lang/Object;
.source "ThemeManager.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/developeramira/remotemediastar/theme/ThemeManager;->toast(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$msg:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;)V
    .locals 0

    .line 1265
    iput-object p1, p0, Lcom/developeramira/remotemediastar/theme/ThemeManager$10;->val$msg:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 1269
    :try_start_0
    invoke-static {}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->access$200()Landroid/content/Context;

    move-result-object v0

    .line 1270
    if-eqz v0, :cond_0

    .line 1271
    iget-object v1, p0, Lcom/developeramira/remotemediastar/theme/ThemeManager$10;->val$msg:Ljava/lang/String;

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1274
    :cond_0
    goto :goto_0

    .line 1273
    :catchall_0
    move-exception v0

    .line 1275
    :goto_0
    return-void
.end method
