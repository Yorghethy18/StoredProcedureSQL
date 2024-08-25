# Crear un usuario en SQL Plus (desde la terminal)

```bash
Introduzca el nombre de usuario: /as sysdba
```

**/as sysdba** Es el usuario por defecto de Oracle DB Express

---

Comando para habilitar las operaciones restringidas (como la creación de usarios)

```bash
SQL> ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
```

---

Comando para crear un usuario:  
CREATE USER **[NOMBRE DEL USUARIO]** IDENTIFIED BY "**[PASSWORD]**"

```bash
SQL> CREATE USER USER_NOOB IDENTIFIED BY "USER_NOOB"
  2  DEFAULT TABLESPACE "USERS"
  3  TEMPORARY TABLESPACE "TEMP";
```

**DEFAULT TABLESPACE "USERS"** define el espacio de tablas donde se almacenarán las tablas del usuario  
**TEMPORARY TABLESPACE "TEMP"** define el espacio temporal donde se almacenarán los datos temporales
Usuario creado.

---

Comando para habilitar al usuario para que use todo el espacio disponible en el TABLESPACE antes definido, en este caso **TABLESPACE "USERS" :**

```bash
SQL> ALTER USER USER_NOOB QUOTA UNLIMITED ON USERS;
```

---

Comando para habilitar al usuario para iniciar sesión:

```bash
SQL> GRANT CREATE SESSION TO USER_NOOB;
```

---

Comando para habilitar al usuario a realizar varias operaciones:

```bash
SQL> GRANT "RESOURCE" TO USER_NOOB;
```

**"RESOURCE"** incluye varios privilegios.

---

Comando para asignar el rol **"RESOURCE"** al usuario **USER_NOOB :**

```bash
SQL> ALTER USER USER_NOOB DEFAULT ROLE "RESOURCE";
```

El asignar este rol quiere decir que cuando el usuario inicie sesión, se asociarán los privilegios de acuerdo al rol, sin la necesidad de ser activados de forma manual:
