.class Lcom/saminsoftware/remotemediastar/theme/ThemeManager$9$1;
.super Ljava/lang/Object;
.source "ThemeManager.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/saminsoftware/remotemediastar/theme/ThemeManager$9;->onClick(Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/saminsoftware/remotemediastar/theme/ThemeManager$9;


# direct methods
.method constructor <init>(Lcom/saminsoftware/remotemediastar/theme/ThemeManager$9;)V
    .locals 0

    .line 1243
    iput-object p1, p0, Lcom/saminsoftware/remotemediastar/theme/ThemeManager$9$1;->this$0:Lcom/saminsoftware/remotemediastar/theme/ThemeManager$9;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 0

    .line 1246
    invoke-static {}, Lcom/saminsoftware/remotemediastar/theme/ThemeManager;->applyThemeLive()V

    .line 1247
    return-void
.end method
