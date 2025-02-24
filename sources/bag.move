/// Module: bags
module bags::bag{
    use sui::dynamic_field;
    use sui::bag;

    // Set up Hero object structure
    public struct Hero has key, store {
        id: UID
    }

    //Will hold a vector of 100 u64s
    public struct Wrapper has store, drop {
        //vec: vector<Three_Slot_Struct>,
        vec: vector<u64>,
    }

    // The Child that holds the object containing the vector
    public struct Child has key, store {
        id: UID,
        wrapper: Wrapper
    }

     public fun create_Vector_of_Struct(): Wrapper{
        //1) Create empty vector to store structs
        //let mut temp_vector = vector::empty<Three_Slot_Struct>();
        let mut temp_vector = vector::empty<u64>();

        //2) Loop through creating struct instances & storing in vector
        let mut i = 0;
        while(i < 100){
            //2A) Create struct instance storing values of i
            /*let temp_struct = Three_Slot_Struct{
                field1: i,
            };*/

            //2B) Store struct into vector
            //vector::push_back(&mut temp_vector, temp_struct);
            vector::push_back(&mut temp_vector, i);            

            i = i + 1;
        };

        //3) Create object with previously created vector of structs
        let object = Wrapper{
            vec: temp_vector
        };

        object
    }

    // Create many hero objects. 
    // In each iteration, creates hero object, create and add 3 accessories to a bag, add bag to hero as a dynamic field
    public entry fun create_heroes_with_bag_in_dynamic_field(ctx: &mut TxContext){
        let mut i = 0;
        while (i < 62){
            // Create Hero object
            let mut hero = Hero{id: object::new(ctx)};

            // creating bag
            let mut bag_object = bag::new(ctx);

            
            // creating 15 Child objects
            let mut j: u64 = 0;
            while(j < 15) {
                let object = create_Vector_of_Struct();

                let obj = Child{id: object::new(ctx), wrapper: object};
                bag::add(&mut bag_object, j, obj);
                j = j + 1;
            };
            
            // adding bag as dynamic fields
            dynamic_field::add(&mut hero.id, b"bag", bag_object);
            transfer::transfer(hero, tx_context::sender(ctx));
            i = i + 1;
        }
    }
}