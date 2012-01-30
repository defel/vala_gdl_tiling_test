class Window : Gtk.Window
{
  private Gdl.DockMaster master;
  private Gdl.DockLayout layout;

  private void save_layout_cb ()
  {
    int response;
    Gtk.HBox hbox;
    Gtk.Label label;
    Gtk.Entry entry;
    Gtk.Dialog dialog;

    dialog = new Gtk.Dialog.with_buttons ("New Layout", null,
                                          Gtk.DialogFlags.MODAL |
                                          Gtk.DialogFlags.DESTROY_WITH_PARENT,
                                          Gtk.STOCK_OK,
                                          Gtk.ResponseType.OK);

    hbox = new Gtk.HBox (false, 8);
    hbox.set_border_width (8);
    dialog.vbox.pack_start (hbox, false, false, 0);

    label = new Gtk.Label ("Name:");
    hbox.pack_start (label, false, false, 0);

    entry = new Gtk.Entry ();
    hbox.pack_start (entry, true, true, 0);

    hbox.show_all ();
    response = dialog.run ();

    if (response == Gtk.ResponseType.OK)
    {
      string name;

      name = entry.get_text ();
      this.layout.save_layout (name);
    }
    dialog.destroy ();
  }

  private void run_layout_manager_cb ()
  {
    this.layout.run_manager ();
  }

  private void button_dump_cb ()
  {
    try
    {
      /* Dump XML tree. */
      this.layout.save_to_file ("layout.xml");
      Process.spawn_command_line_async ("cat layout.xml");
    }
    catch (Error e)
    {
      warning (e.message);
    }
  }

  private void on_style_button_toggled (Gtk.ToggleButton button)
  {
    bool active;
    Gdl.SwitcherStyle style;

    style = (Gdl.SwitcherStyle)button.get_data ("__style_id");
    active = button.get_active ();
    if (active)
    {
      this.master.switcher_style = style;
    }
  }

  private Gtk.RadioButton create_style_button (Gtk.VBox box,
                                               Gtk.RadioButton? group,
                                               Gdl.SwitcherStyle style,
                                               string style_text)
  {
    Gtk.RadioButton button1;
    Gdl.SwitcherStyle current_style;

    current_style = this.master.switcher_style;
    button1 = new Gtk.RadioButton.with_label_from_widget (group, style_text);
    button1.show ();
    button1.set_data ("__style_id", (void*)style);
    if (current_style == style)
    {
      button1.set_active (true);
    }
    button1.toggled.connect (this.on_style_button_toggled);
    box.pack_start (button1, false, false, 0);
    return button1;
  }

  private Gtk.Widget create_styles_item (Gdl.Dock dock)
  {
    Gtk.VBox vbox1;
    Gtk.RadioButton group;

    vbox1 = new Gtk.VBox (false, 0);
    vbox1.show ();

    group = this.create_style_button (vbox1, null, Gdl.SwitcherStyle.ICON,
                                      "Only icon");
    group = this.create_style_button (vbox1, group, Gdl.SwitcherStyle.TEXT,
                                      "Only text");
    group = this.create_style_button (vbox1, group, Gdl.SwitcherStyle.BOTH,
                                      "Both icons and texts");
    group = this.create_style_button (vbox1, group, Gdl.SwitcherStyle.TOOLBAR,
                                      "Desktop toolbar style");
    group = this.create_style_button (vbox1, group, Gdl.SwitcherStyle.TABS,
                                      "Notebook tabs");
    return vbox1;
  }

  private Gtk.Widget create_item (string button_title)
  {
    Gtk.VBox vbox1;
    Gtk.Button button1;

    vbox1 = new Gtk.VBox (false, 0);
    vbox1.show ();

    button1 = new Gtk.Button.with_label (button_title);
    button1.show ();
    vbox1.pack_start (button1, true, true, 0);

    return vbox1;
  }

  /* creates a simple widget with a textbox inside */
  private Gtk.Widget create_text_item ()
  {
    Gtk.VBox vbox1;
    Gtk.ScrolledWindow scrolledwindow1;
    Gtk.TextView text;

    vbox1 = new Gtk.VBox (false, 0);
    vbox1.show ();

    scrolledwindow1 = new Gtk.ScrolledWindow (null, null);
    scrolledwindow1.show ();
    vbox1.pack_start (scrolledwindow1, true, true, 0);
    scrolledwindow1.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
    scrolledwindow1.set_shadow_type (Gtk.ShadowType.ETCHED_IN);
    text = new Gtk.TextView ();
    //text.wrap_mode = GTK_WRAP_WORD;
    text.show ();
    scrolledwindow1.add (text);

    return vbox1;
  }

  construct
  {
    Gtk.HBox box;
    Gdl.Dock dock;
    Gtk.VBox table;
    Gtk.Button button;
    Gdl.DockBar dockbar;
    Gdl.DockItem item1, item2, item3;
    Gdl.DockItem[4] items;

    this.destroy.connect (Gtk.main_quit);
    this.set_title ("Docking widget test");
    this.set_default_size (400, 400);

    table = new Gtk.VBox (false, 5);
    table.set_border_width (10);
    this.add (table);

    /* create the dock */
    dock = new Gdl.Dock ();
    this.master = dock.master;

    /* ... and the layout manager */
    this.layout = new Gdl.DockLayout (dock);

    /* create the dockbar */
    dockbar = new Gdl.DockBar (dock);
    dockbar.set_style (Gdl.DockBarStyle.TEXT);

    box = new Gtk.HBox (false, 5);
    table.pack_start (box, true, true, 0);

    box.pack_start (dockbar, false, false, 0);
    box.pack_end (dock, true, true, 0);

    /* create the dock items */
    item1 = new Gdl.DockItem ("item1", "Item #1", Gdl.DockItemBehavior.LOCKED);
    item1.add (create_text_item ());
    dock.add_item (item1, Gdl.DockPlacement.TOP);
    item1.show ();

    item2 = new Gdl.DockItem.with_stock ("item2", "Item #2: Select the switcher style for notebooks",
                                         Gtk.STOCK_EXECUTE,
                                         Gdl.DockItemBehavior.NORMAL);
    item2.resize = false;
    item2.add (create_styles_item (dock));
    dock.add_item (item2, Gdl.DockPlacement.RIGHT);
    item2.show ();

    item3 = new Gdl.DockItem.with_stock ("item3", "Item #3 has accented characters (áéíóúñ)",
                                         Gtk.STOCK_CONVERT,
                                         Gdl.DockItemBehavior.NORMAL |
                                         Gdl.DockItemBehavior.CANT_CLOSE);
    item3.add (create_item ("Button 3"));
    dock.add_item (item3, Gdl.DockPlacement.BOTTOM);
    item3.show ();

    items = new Gdl.DockItem[4];
    items [0] = new Gdl.DockItem.with_stock ("Item #4", "Item #4",
                                             Gtk.STOCK_JUSTIFY_FILL,
                                             Gdl.DockItemBehavior.NORMAL |
                                             Gdl.DockItemBehavior.CANT_ICONIFY);
    items[0].add (create_text_item ());
    items[0].show ();
    dock.add_item (items [0], Gdl.DockPlacement.BOTTOM);
    for (int i = 1; i < 3; i++)
    {
      string name;

      name = "Item #%d".printf (i + 4);
      items[i] = new Gdl.DockItem.with_stock (name, name, Gtk.STOCK_NEW,
                                              Gdl.DockItemBehavior.NORMAL);
      items[i].add (create_text_item ());
      items[i].show ();

      items[0].dock (items [i], Gdl.DockPlacement.CENTER, null);
    }

    /* tests: manually dock and move around some of the items */
    item3.dock_to (item1, Gdl.DockPlacement.TOP, -1);

    item2.dock_to (item3, Gdl.DockPlacement.RIGHT, -1);

    item2.dock_to (item3, Gdl.DockPlacement.LEFT, -1);

    item2.dock_to (null, Gdl.DockPlacement.FLOATING, -1);

    box = new Gtk.HBox (true, 5);
    table.pack_end (box, false, false, 0);

    button = new Gtk.Button.from_stock (Gtk.STOCK_SAVE);
    button.clicked.connect (this.save_layout_cb);
    box.pack_end (button, false, true, 0);

    button = new Gtk.Button.with_label ("Layout Manager");
    button.clicked.connect (this.run_layout_manager_cb);
    box.pack_end (button, false, true, 0);

    button = new Gtk.Button.with_label ("Dump XML");
    button.clicked.connect (this.button_dump_cb);
    box.pack_end (button, false, true, 0);

    new Gdl.DockPlaceholder ("ph1", dock, Gdl.DockPlacement.TOP, false);
    new Gdl.DockPlaceholder ("ph2", dock, Gdl.DockPlacement.BOTTOM, false);
    new Gdl.DockPlaceholder ("ph3", dock, Gdl.DockPlacement.LEFT, false);
    new Gdl.DockPlaceholder ("ph4", dock, Gdl.DockPlacement.RIGHT, false);
  }
}

void main (string[] args)
{
  Window win;

  Gtk.init (ref args);

  win = new Window ();
  win.show_all ();

  Gtk.main ();
}
