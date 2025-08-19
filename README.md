# Cafetería en Sui: Guía de Funcionamiento y Uso

![Move](https://img.shields.io/badge/Language-Move-blue)
![Sui](https://img.shields.io/badge/Blockchain-Sui-0079FF)
![License](https://img.shields.io/badge/License-MIT-green)

Bienvenido a la documentación del proyecto "Cafetería en Sui". Este documento explica la lógica interna del contrato inteligente (cómo funciona) y proporciona una guía práctica sobre cómo interactuar con él en la Mainnet de Sui (cómo utilizarlo).

## 🧠 ¿Cómo Funciona?

El contrato opera bajo una lógica simple con dos roles principales: el **Administrador** (dueño de la cafetería) y el **Usuario** (cliente). El sistema se basa en objetos on-chain que representan cada componente de la cafetería.

### Actores

* **Administrador:** Es la única cuenta con permiso para crear nuevos productos. Este rol lo obtiene automáticamente la persona que despliega el contrato.
* **Usuario:** Cualquier cuenta en la red de Sui que desee comprar un producto.

### Objetos Principales

* `AdminCap` (Capacidad de Administrador): Es un objeto especial que funciona como una "llave de administrador". Solo la cuenta que posee este objeto puede llamar a la función para agregar productos. Se crea una sola vez durante el despliegue.
* `Producto`: Cada producto a la venta (ej. "Café Americano") es un objeto único en la blockchain. Contiene su nombre, descripción, precio y la dirección del administrador que debe recibir el pago.
* `Recibo`: Un objeto que se genera y se entrega al comprador como comprobante digital de su compra.

### Flujo de Interacción

1.  **Despliegue (`init`):** Cuando el contrato se publica en Sui, la función `init` se ejecuta automáticamente, creando el `AdminCap` y transfiriéndolo a la billetera del administrador.
2.  **Creación de Producto (`agregar_producto`):** El administrador utiliza su `AdminCap` como autorización para llamar a esta función. La función crea un nuevo objeto `Producto` y lo transfiere a la billetera del administrador, dejándolo listo para la venta.
3.  **Compra de Producto (`comprar_producto`):**
    * Un usuario decide qué `Producto` comprar.
    * Llama a la función `comprar_producto`, entregando el objeto `Producto` y una `Coin` para el pago.
    * El contrato verifica que el valor de la `Coin` sea suficiente.
    * El contrato transfiere el `Producto` y un nuevo `Recibo` al usuario.
    * El contrato separa el pago exacto, lo transfiere al administrador y devuelve el cambio al usuario.

## 🚀 ¿Cómo Utilizarlo?

Este contrato está **activo en la Mainnet de Sui**. Para interactuar con él, necesitas tener la [Sui CLI](https://docs.sui.io/guides/get-started/sui-install) configurada.

### Datos del Contrato en Mainnet

* **Package ID (Dirección del Contrato):**
    `0x0957339383d1dfdaa9c41e63bf515a502817c040250609991b4892e8d44af7d5`
* **Ver en el Explorador (SuiScan):**
    [https://suiscan.xyz/mainnet/package/0x0957339383d1dfdaa9c41e63bf515a502817c040250609991b4892e8d44af7d5](https://suiscan.xyz/mainnet/package/0x0957339383d1dfdaa9c41e63bf515a502817c040250609991b4892e8d44af7d5)

### Para el Administrador: Agregar un Producto

Para agregar un nuevo producto al menú, ejecuta el siguiente comando:

```bash
sui client call \
  --function agregar_producto \
  --module cafeteria \
  --package 0x0957339383d1dfdaa9c41e63bf515a502817c040250609991b4892e8d44af7d5 \
  --args <ID_DEL_ADMIN_CAP> 'b"Nombre del Producto"' 'b"Descripción del producto."' <PRECIO_EN_MIST> \
  --gas-budget 5000000
```
**Argumentos a reemplazar:**
* `--args`:
    1.  `<ID_DEL_ADMIN_CAP>`: El ID de tu objeto `AdminCap` (lo obtuviste al desplegar).
    2.  `'b"Nombre del Producto"'`: El nombre de tu producto, ej. `'b"Capuchino"'`.
    3.  `'b"Descripción del producto."'`: Una breve descripción.
    4.  `<PRECIO_EN_MIST>`: El precio en MIST (1 SUI = 1,000,000,000 MIST).

### Para los Usuarios: Comprar un Producto

Una vez que un producto ha sido creado, cualquiera puede comprarlo con este comando:

```bash
sui client call \
  --function comprar_producto \
  --module cafeteria \
  --package 0x0957339383d1dfdaa9c41e63bf515a502817c040250609991b4892e8d44af7d5 \
  --args <ID_DEL_PRODUCTO> <ID_DE_LA_MONEDA_DE_PAGO> \
  --gas-budget 5000000
```
**Argumentos a reemplazar:**
* `--args`:
    1.  `<ID_DEL_PRODUCTO>`: El ID del objeto `Producto` que se va a comprar.
    2.  `<ID_DE_LA_MONEDA_DE_PAGO>`: El ID de una `Coin<SUI>` que poseas con fondos suficientes. Puedes ver tus monedas con el comando `sui client gas`.

## 👤 Autor

**marioayala196**
