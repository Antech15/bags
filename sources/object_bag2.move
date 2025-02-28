/// Module: bags
module bags::object_bag2 {
    use sui::dynamic_field;
    use sui::object_bag;

    public struct Hero has key, store {
        id: UID
    }

    public struct Wrapper has store, drop {
        num: u64,
    }

    public struct Child has key, store {
        id: UID,
        wrapper: Wrapper
    }

     public fun create_Vector_of_Struct(): Wrapper{
        let mut temp_vector = vector::empty<u64>();

        let mut i = 0;
        while(i < 100){
            vector::push_back(&mut temp_vector, i);            
            i = i + 1;
        };

        let object = Wrapper{
            num: 1
        };

        object
    }

    public entry fun create_heroes_with_bag_in_dynamic_field(ctx: &mut TxContext){
        let mut i = 0;
        while (i < 20){
            let mut hero = Hero{id: object::new(ctx)};

            let mut bag_object = object_bag::new(ctx);

            let mut j: u64 = 0;
            while(j < 15) {
                let object = create_Vector_of_Struct();

                let obj = Child{id: object::new(ctx), wrapper: object};
                object_bag::add(&mut bag_object, j, obj);
                j = j + 1;
            };
            
            dynamic_field::add(&mut hero.id, b"bag", bag_object);
            transfer::transfer(hero, tx_context::sender(ctx));
            i = i + 1;
        }
    }

    public entry fun create_one_heroe_with_bag_in_dynamic_field(ctx: &mut TxContext){
        let mut hero = Hero{id: object::new(ctx)};

        let mut bag_object = object_bag::new(ctx);

        let mut j: u64 = 0;
        while(j < 15) {
            let object = create_Vector_of_Struct();

            let obj = Child{id: object::new(ctx), wrapper: object};
            object_bag::add(&mut bag_object, j, obj);
            j = j + 1;
        };
            
        dynamic_field::add(&mut hero.id, b"bag", bag_object);
        transfer::transfer(hero, tx_context::sender(ctx));        
    }

    public entry fun access_hero_with_bag_in_dynamic_field(hero_obj_ref: &mut Hero): u64{
        let mut i = 0;
        
        let mut bag_ref: &mut object_bag::ObjectBag;
        let mut child: &mut Child;
        let mut temp: u64 = 0;

        while (i < 15){
            bag_ref = dynamic_field::borrow_mut(&mut hero_obj_ref.id, b"bag");
            child = object_bag::borrow_mut(bag_ref, i);
            temp = temp + child.wrapper.num;
            i = i + 1;
        };
        temp
    }

    public entry fun update_hero_with_bag_in_dynamic_field(hero_obj_ref: &mut Hero){
        let mut i = 0;

        let mut bag_ref: &mut object_bag::ObjectBag;
        let mut child: &mut Child;

        while (i < 15){
            bag_ref = dynamic_field::borrow_mut(&mut hero_obj_ref.id, b"bag");

            child = object_bag::borrow_mut(bag_ref, i);
            child.wrapper.num = i;

            i = i + 1;
        }
    }
}