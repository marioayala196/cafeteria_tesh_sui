// sources/cafeteria_tesh_sui.move

module cafeteria_tesh_sui::cafeteria {
    // --- Imports (Versión Robusta y Explícita) ---
    use sui::object;
    use sui::transfer;
    use sui::tx_context;
    use sui::coin;
    use sui::sui::SUI;

    // --- Errores Personalizados ---
    const EPAGO_INSUFICIENTE: u64 = 1;

    // --- Structs ---
    public struct AdminCap has key, store {
        id: object::UID
    }
    public struct Producto has key, store {
        id: object::UID,
        nombre: vector<u8>,
        descripcion: vector<u8>,
        precio: u64,
        admin: address
    }
    public struct Recibo has key, store {
        id: object::UID,
        nombre_producto: vector<u8>,
        monto_pagado: u64,
        comprador: address
    }

    // --- Funciones (init y agregar_producto sin cambios) ---
    fun init(ctx: &mut tx_context::TxContext) {
        transfer::public_transfer(AdminCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx))
    }
    public entry fun agregar_producto(
        _: &AdminCap,
        nombre: vector<u8>,
        descripcion: vector<u8>,
        precio: u64,
        ctx: &mut tx_context::TxContext
    ) {
        let creador = tx_context::sender(ctx);
        let producto = Producto {
            id: object::new(ctx),
            nombre,
            descripcion,
            precio,
            admin: creador
        };
        transfer::public_transfer(producto, creador);
    }


    // --- FUNCIÓN ---
    public entry fun comprar_producto(
        producto: Producto,
        mut pago: coin::Coin<SUI>,
        ctx: &mut tx_context::TxContext
    ) {
        assert!(coin::value(&pago) >= producto.precio, EPAGO_INSUFICIENTE);

        let comprador = tx_context::sender(ctx);
        let direccion_admin = producto.admin;
        
        // --- PRODUCTO ---
        // 1. Guardamos los datos que necesitaremos MÁS TARDE en variables locales.
        let nombre_del_producto_comprado = producto.nombre;
        let precio_del_producto_comprado = producto.precio;

        // 2. Ahora que ya tenemos los datos, transferimos (movemos) el producto.
        transfer::public_transfer(producto, comprador);

        // 3. Procedemos con el resto de la lógica usando las variables locales.
        let fondos_pago = coin::split(&mut pago, precio_del_producto_comprado, ctx);
        transfer::public_transfer(fondos_pago, direccion_admin);
        
        let recibo = Recibo {
            id: object::new(ctx),
            nombre_producto: nombre_del_producto_comprado, // Usamos la variable local
            monto_pagado: precio_del_producto_comprado,    // Usamos la variable local
            comprador
        };
        transfer::public_transfer(recibo, comprador);

        transfer::public_transfer(pago, comprador);
    }
}