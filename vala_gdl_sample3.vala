
// ACME ( Tiling Layout, Apps(Browser, E-Mail, .. ) ) 

using Gtk;
using WebKit; 

class Browser : Gtk.VBox {
	private Gtk.ScrolledWindow scrolledwindow; 
	private WebKit.WebView web;
	private Entry url_bar; 
	
	private void on_activate () {
		web.open(url_bar.text);
	}
	
	private void create_scrolled_window () {
		scrolledwindow = new Gtk.ScrolledWindow (null, null);
        scrolledwindow.show ();
        this.pack_start (scrolledwindow, true, true, 0);
        scrolledwindow.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scrolledwindow.set_shadow_type (Gtk.ShadowType.ETCHED_IN);
	}
	
	private void create_web () {
		web = new WebKit.WebView ();
        web.open("http://live.gnome.org/Vala/WebKitSample");
        scrolledwindow.add (web);
        web.show();
	}
	
	private void create_url_bar () {
        url_bar = new Entry(); 
        url_bar.activate.connect(this.on_activate); 
        this.pack_start (url_bar, false, true, 0);
	}
	
	construct
    {
        this.show ();
        this.create_scrolled_window(); 
        this.create_web(); 
        this.create_url_bar(); 
    }
}

class Window : Gtk.Window {
	public 	string 					buttonTitle;
	
	private Gdl.DockMaster 	master;
	private Gdl.DockLayout 	layout;
	private Gdl.DockBar 		dockbar; 
	private Gdl.Dock 				dock; 
	
	private int count = 1;
	
	// TEST ITEM
	public Gtk.VBox testItem () {
			stdout.printf("Builder: create testItem \n");
			var testItem = new Gtk.VBox (false, 0);
			testItem.show(); 
			
			testItem.pack_start( testButton(), true, true, 0);
			return testItem; 
	}
	
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
  
  private Gtk.Widget create_socket_item() 
  {
    Gtk.Socket socket; 
    Gtk.VBox vbox1;
    Gtk.ScrolledWindow scrolledwindow1;
    
    vbox1 = new Gtk.VBox (false, 0);
    vbox1.show ();
    
    scrolledwindow1 = new Gtk.ScrolledWindow (null, null);
    scrolledwindow1.show ();
    vbox1.pack_start (scrolledwindow1, true, true, 0);
    scrolledwindow1.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
    scrolledwindow1.set_shadow_type (Gtk.ShadowType.ETCHED_IN);

    socket = new Gtk.Socket(); 
    socket.show();
//    stdout.printf("Socket created: %d \n", socket.get_id());

    scrolledwindow1.add (socket);

    return vbox1;
  }
  
	private Gtk.Widget create_browser_item ()
  {
    return new Browser(); 
  }
	
	public void addItem (int i) {
		var item1 = new Gdl.DockItem ("item%d".printf(count), "Item #%d".printf(count), Gdl.DockItemBehavior.NORMAL);
		switch(i) {
			case 1: 
				item1.add (create_text_item ());
				break; 
			case 2: 
				item1.add (create_browser_item ());
				break;
			case 3: 
				item1.add (create_socket_item ());
				break;
		}; 
    
    dock.add_item (item1, Gdl.DockPlacement.TOP);
    item1.show_all ();
    count++;
	}

	// TEST BUTTON
	public Gtk.Widget testButton () {
			stdout.printf("Builder: create testButton \n");
			var testButton = new Gtk.Button.with_label (buttonTitle);
    	testButton.show ();
    	return testButton;
		
	}
	
	// START BOX
	public Gtk.HBox startBox () {
			stdout.printf("Builder: create startBox \n");
			var startBox = new Gtk.HBox (false, 5);

			startBox.pack_start (dockbar, false, false, 0);
		  startBox.pack_end (dock, true, true, 0);
		  return startBox; 
    
	}
	
	// END BOX
	public Gtk.HBox endBox () {
			stdout.printf("Builder: create endBox \n");
			var endBox = new Gtk.HBox (false, 5);
			
			var nbr_button = new Gtk.Button.with_label ("New Browser");
  	  nbr_button.clicked.connect ((t) => { addItem(2); });
	    endBox.pack_end (nbr_button, false, true, 0);
	    
	    var ntw_button = new Gtk.Button.with_label ("New Textwin");
  	  ntw_button.clicked.connect ((t) => { addItem(1); });
	    endBox.pack_end (ntw_button, false, true, 0);
	    
			return endBox;   
	}
	
	// MAIN TABLE
	public Gtk.VBox mainTable () {
			stdout.printf("Builder: create mainTable \n");
			var table = new Gtk.VBox (false, 5);
		  table.set_border_width (10);
		  add (table);
		  
		  table.pack_start(startBox(), true, true, 0);
		  table.pack_end (endBox(), false, false, 0);
		  table.show_all();
		  
		  return table; 
    
  }
  
  //////////////////////
  
  public Window() {
  
  }
  
  construct
  {
	  this.destroy.connect (Gtk.main_quit);
  	this.set_default_size (400, 400);
  	
  	//return win; 
  	
  	dock = new Gdl.Dock (); 
		master = dock.master;
		layout = new Gdl.DockLayout (dock);
		dockbar = new Gdl.DockBar (dock);
		dockbar.set_style (Gdl.DockBarStyle.TEXT);
  	
  	mainTable();
  	addItem(1); 
  	addItem(1); 
	 	addItem(2); 
  	this.show_all(); 
  	
  	//this.add();
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

class Main : GLib.Object  {
	private Window win; 
	
	construct
  {
  	this.win = new Window(); 
  }
}

void main (string[] args)
{
  Gtk.init (ref args);

  Main main = new Main ();

  Gtk.main ();
}
