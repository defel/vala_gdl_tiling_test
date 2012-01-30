class Builder {
	public string buttonTitle;
	
	private Gdl.DockMaster master;
	private Gdl.DockLayout layout;
	 
	public Gdl.Dock dock {
		get { 
			stdout.printf("Builder: create dock \n");
			dock = new Gdl.Dock (); 
			master = dock.master;
			layout = new Gdl.DockLayout (dock);
			return dock; 
		}
		set { /* dock = value;*/ }
	}
	

	public Gtk.VBox testItem {
		get {
			stdout.printf("Builder: create testItem \n");
			testItem = new Gtk.VBox (false, 0);
			testItem.show(); 
			
			testItem.pack_start( testButton, true, true, 0);
			return testItem; 
		}
		set {}
	}

	public Gtk.Widget testButton {
		get {
			stdout.printf("Builder: create testButton \n");
			testButton = new Gtk.Button.with_label (buttonTitle);
    	testButton.show ();
    	return testButton;
		}
		set {}
	}
	
	public Gtk.VBox mainTable {
		get {
			stdout.printf("Builder: create mainTable \n");
			Gtk.VBox table = new Gtk.VBox (false, 5);
		  table.set_border_width (10);
		  this.add (table);
		  
		  table.pack_start(create_startBox(), false, false, 0);
		  table.pack_end (create_endBox(), false, false, 0);
		  
		  return table; 
    }
  }
  
  public Gtk.Window window {
  	get {
  		Gtk.Window window = new Gtk.Window();
	  	window.set_default_size (400, 400);
	  	
	  	window.show_all(); 
  	}
  }
}

struct UI {
	public Gtk.VBox table;
	public Gdl.Dock dock;
	public Gdl.DockBar dockbar;
	public Gtk.HBox box;
	public Gtk.Button button;
	public Gdl.DockItem item1; 
	public Gdl.DockItem item2; 
	public Gdl.DockItem item3;
	public Gdl.DockItem[] items;
}

class Main {
	private Builder builder; 
	
	construct
  {
  	this.builder = new Builder(); 
  }
}


class Window : Gtk.Window
{
	private Builder builder; 
  
  

  private Gtk.Widget create_item (string button_title)
  {
  	return builder.testItem;
  }

  /* creates a simple widget with a textbox inside 
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
  }*/
  
  private Gtk.VBox init_table() {
  	return builder.mainTable; 
    
  }
  
  private Gdl.Dock init_doc() {
  	 return builder.dock; 
  }
  /*
  private Gtk.HBox create_endBox() {
	  Gtk.HBox box = new Gtk.HBox (true, 5);

		// add more buttons here .. 
    Gtk.Button button = new Gtk.Button.from_stock (Gtk.STOCK_SAVE);
    // button.clicked.connect (this.save_layout_cb);
    box.pack_end (button, false, true, 0);
    return box; 
  }
  
  private Gtk.HBox create_startBox(Gdl.DockBar dockbar) {
	  Gtk.HBox box = new Gtk.HBox (false, 5);

		/* create the dockbar * /
    dockbar = new Gdl.DockBar (dock);
    dockbar.set_style (Gdl.DockBarStyle.TEXT);
		
		box.pack_start (dockbar, false, false, 0);
    box.pack_end (dock, true, true, 0);
  }*/

  construct
  {
  	this.builder = new Builder(); 
  	this.destroy.connect (Gtk.main_quit);
    this.set_title ("Docking widget test");
    var table		 	= init_table(); 
    var dock 		 	= init_doc(); 
/*
    
    
    



    
    
    var box = init_box();

    box = new Gtk.HBox (false, 5);
    table.pack_start (box, true, true, 0);

    

    /* create the dock items * /
    item1 = new Gdl.DockItem ("item1", "Item #1", Gdl.DockItemBehavior.LOCKED);
    item1.add (create_text_item ());
    dock.add_item (item1, Gdl.DockPlacement.TOP);
    item1.show ();

    item2 = new Gdl.DockItem.with_stock ("item2", "Item #2: Select the switcher style for notebooks",
                                         Gtk.STOCK_EXECUTE,
                                         Gdl.DockItemBehavior.NORMAL);
    item2.resize = false;
    item2.add (create_text_item ());
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

    /* tests: manually dock and move around some of the items * /
    item3.dock_to (item1, Gdl.DockPlacement.TOP, -1);

    item2.dock_to (item3, Gdl.DockPlacement.RIGHT, -1);

    item2.dock_to (item3, Gdl.DockPlacement.LEFT, -1);

//    item2.dock_to (null, Gdl.DockPlacement.FLOATING, -1);

    


    new Gdl.DockPlaceholder ("ph1", dock, Gdl.DockPlacement.TOP, false);
    new Gdl.DockPlaceholder ("ph2", dock, Gdl.DockPlacement.BOTTOM, false);
    new Gdl.DockPlaceholder ("ph3", dock, Gdl.DockPlacement.LEFT, false);
    new Gdl.DockPlaceholder ("ph4", dock, Gdl.DockPlacement.RIGHT, false);*/
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
