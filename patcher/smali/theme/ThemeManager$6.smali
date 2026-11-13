.class final Lcom/saminsoftware/remotemediastar/theme/ThemeManager$6;
.super Ljava/lang/Object;
.source "ThemeManager.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/saminsoftware/remotemediastar/theme/ThemeManager;->socialRow(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/view/View;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$handle:Ljava/lang/String;

.field final synthetic val$url:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 964
    iput-object p1, p0, Lcom/saminsoftware/remotemediastar/theme/ThemeManager$6;->val$url:Ljava/lang/String;

    iput-object p2, p0, Lcom/saminsoftware/remotemediastar/theme/ThemeManager$6;->val$handle:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 1

    .line 967
    invoke-static {p1}, Lcom/saminsoftware/remotemediastar/theme/ThemeManager;->pulse(Landroid/view/View;)V

    .line 968
    iget-object p1, p0, Lcom/saminsoftware/remotemediastar/theme/ThemeManager$6;->val$url:Ljava/lang/String;

    iget-object v0, p0, Lcom/saminsoftware/remotemediastar/theme/ThemeManager$6;->val$handle:Ljava/lang/String;

    invoke-static {p1, v0}, Lcom/saminsoftware/remotemediastar/theme/ThemeManager;->openLink(Ljava/lang/String;Ljava/lang/String;)Z

    .line 969
    return-void
.end method
