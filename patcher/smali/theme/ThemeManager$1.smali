.class final Lcom/saminsoftware/remotemediastar/theme/ThemeManager$1;
.super Ljava/lang/Object;
.source "ThemeManager.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/saminsoftware/remotemediastar/theme/ThemeManager;->hideSettingsPanel()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$panel:Lanywheresoftware/b4a/objects/PanelWrapper;


# direct methods
.method constructor <init>(Lanywheresoftware/b4a/objects/PanelWrapper;)V
    .locals 0

    .line 514
    iput-object p1, p0, Lcom/saminsoftware/remotemediastar/theme/ThemeManager$1;->val$panel:Lanywheresoftware/b4a/objects/PanelWrapper;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 518
    :try_start_0
    iget-object v0, p0, Lcom/saminsoftware/remotemediastar/theme/ThemeManager$1;->val$panel:Lanywheresoftware/b4a/objects/PanelWrapper;

    invoke-virtual {v0}, Lanywheresoftware/b4a/objects/PanelWrapper;->RemoveView()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 520
    goto :goto_0

    .line 519
    :catchall_0
    move-exception v0

    .line 521
    :goto_0
    return-void
.end method
