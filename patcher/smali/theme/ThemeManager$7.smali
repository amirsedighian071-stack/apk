.class final Lcom/developeramira/remotemediastar/theme/ThemeManager$7;
.super Ljava/lang/Object;
.source "ThemeManager.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/developeramira/remotemediastar/theme/ThemeManager;->hideThemeChooser()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$v:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/view/View;)V
    .locals 0

    .line 1099
    iput-object p1, p0, Lcom/developeramira/remotemediastar/theme/ThemeManager$7;->val$v:Landroid/view/View;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 1102
    iget-object v0, p0, Lcom/developeramira/remotemediastar/theme/ThemeManager$7;->val$v:Landroid/view/View;

    invoke-static {v0}, Lcom/developeramira/remotemediastar/theme/ThemeManager;->access$000(Landroid/view/View;)V

    .line 1103
    return-void
.end method
