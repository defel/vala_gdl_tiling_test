
public class Test.MyClass1 : GLib.Object {
    delegate void DelegateType(string a); 

    public static int main(string[] args) {
        DelegateType a1 = (a) => { stdout.printf("Foo");}; 

        a1("Fiep"); 

        stdout.printf("Baz");
        return 0; 
    }
}
