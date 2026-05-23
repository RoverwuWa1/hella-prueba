//=================================================================
// Pantalla de perfil (Ever) NO TOCAR a menos que ya se tenga idea del diseño
// de la app y se consulte
//=================================================================


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/services/auth_services.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================================
    //  NO TOCAR — Datos del usuario y servicio de auth
    // ============================================================
    final User? user = FirebaseAuth.instance.currentUser;
    final AuthService authService = AuthService();
    // ============================================================

    return Scaffold(
      //  DISEÑO: Color de fondo
      backgroundColor: const Color(0xFFF8F9FA),

      body: SafeArea(
        child: SingleChildScrollView(
          //  DISEÑO: Espaciado horizontal general
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            children: [
              const SizedBox(height: 32),

              // ============================================================
              //  BLOQUE 1 — Avatar y nombre del usuario
              // Pueden cambiar el tamaño del avatar, color de fondo,
              // estilo del nombre y del correo.
              // Los datos (foto, nombre, correo) vienen de Firebase — no tocar.
              // ============================================================
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44, //  Tamaño del avatar
                      backgroundColor: const Color(
                        0xFF4285F4,
                      ), //  Color de fondo del avatar
                      backgroundImage:
                          user?.photoURL !=
                              null //  NO TOCAR
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child:
                          user?.photoURL ==
                              null //  NO TOCAR
                          ? Text(
                              user?.displayName?[0].toUpperCase() ?? 'U',
                              style: const TextStyle(
                                color: Colors.white, //  Color de la inicial
                                fontSize: 28, //  Tamaño de la inicial
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user?.displayName ?? 'Usuario', //  NO TOCAR
                      style: const TextStyle(
                        fontSize: 20, //  Tamaño del nombre
                        fontWeight: FontWeight.w700, //  Peso del nombre
                        color: Color(0xFF1A1A2E), //  Color del nombre
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '', //  NO TOCAR
                      style: const TextStyle(
                        fontSize: 14, //  Tamaño del correo
                        color: Color(0xFF6B7280), //  Color del correo
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ============================================================
              //  BLOQUE 2 — Tarjeta "Mi cuenta"
              // Muestra nombre, correo y proveedor del usuario.
              // Pueden cambiar el título, íconos, colores y etiquetas.
              // Los valores (displayName, email) vienen de Firebase — no tocar.
              // ============================================================
              _SectionCard(
                title: 'Mi cuenta', //  Cambien el título
                children: [
                  _InfoTile(
                    icon: Icons.person_outline_rounded, //  Cambien el ícono
                    label: 'Nombre', //  Cambien la etiqueta
                    value: user?.displayName ?? 'Sin nombre', //  NO TOCAR
                  ),
                  _InfoTile(
                    icon: Icons.email_outlined, //  Cambien el ícono
                    label: 'Correo', //  Cambien la etiqueta
                    value: user?.email ?? 'Sin correo', //  NO TOCAR
                  ),
                  _InfoTile(
                    icon: Icons.verified_outlined, //  Cambien el ícono
                    label: 'Proveedor', //  Cambien la etiqueta
                    value: 'Google', //  NO TOCAR
                    valueColor: const Color(0xFF4285F4), //  Color del valor
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ============================================================
              //  BLOQUE 3 — Tarjeta "Preferencias"
              // Opciones adicionales del perfil.
              // Pueden cambiar el título, íconos, etiquetas y agregar más opciones.
              // El onTap de cada opción es donde conectan la navegación.
              // ============================================================
              _SectionCard(
                title: 'Preferencias', //  Cambien el título
                children: [
                  _ActionTile(
                    icon: Icons.lock_outline_rounded, //  Cambien el ícono
                    label: 'Privacidad', //  Cambien la etiqueta
                    onTap: () {}, //  Conecten la navegación
                  ),
                  _ActionTile(
                    icon: Icons.help_outline_rounded, //  Cambien el ícono
                    label: 'Ayuda', //  Cambien la etiqueta
                    onTap: () {}, //  Conecten la navegación
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ============================================================
              //  BLOQUE 4 — Botón cerrar sesión (NO TOCAR la lógica)
              // Solo pueden cambiar el estilo visual del botón.
              // El onPressed llama a _confirmSignOut — no modificar.
              // ============================================================
              SizedBox(
                width: double.infinity,
                height: 52, //  Alto del botón
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _confirmSignOut(context, authService), //  NO TOCAR
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 18,
                  ), //  Cambien el ícono
                  label: const Text(
                    'Cerrar sesión', //  Cambien el texto
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(
                      0xFFE53935,
                    ), //  Color del texto e ícono
                    side: const BorderSide(
                      color: Color(0xFFFFCDD2), //  Color del borde
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), //  Esquinas
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  //  NO TOCAR — Lógica del diálogo de cierre de sesión
  // ============================================================
  void _confirmSignOut(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cerrar sesión',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('¿Estás seguro que deseas salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authService.signOut();
            },
            child: const Text(
              'Salir',
              style: TextStyle(
                color: Color(0xFFE53935),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
}

// ============================================================
//  WIDGET: _SectionCard — Tarjeta de sección
// Pueden cambiar colores, bordes, sombras y esquinas.
// El título y children se pasan desde arriba.
// ============================================================
class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13, //  Tamaño del título de sección
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280), //  Color del título de sección
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, //  Color de fondo de la tarjeta
            borderRadius: BorderRadius.circular(
              14,
            ), //  Esquinas de la tarjeta
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.04,
                ), //  Color de la sombra
                blurRadius: 10, //  Intensidad de la sombra
                offset: const Offset(0, 2),
              ),
            ],
          ),
          //  NO TOCAR — lógica que dibuja los dividers entre items
          child: Column(
            children: children
                .asMap()
                .entries
                .map(
                  (e) => Column(
                    children: [
                      e.value,
                      if (e.key < children.length - 1)
                        const Divider(
                          height: 1,
                          indent: 52,
                          color: Color(0xFFF0F0F0), //  Color del divisor
                        ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ============================================================
//  WIDGET: _InfoTile — Fila de información (solo lectura)
// Pueden cambiar íconos, colores y tamaños de texto.
// Los valores vienen de Firebase — no tocar.
// ============================================================
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF9CA3AF),
          ), //  Color del ícono
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11, //  Tamaño de la etiqueta
                  color: Color(0xFF9CA3AF), //  Color de la etiqueta
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value, //  NO TOCAR
                style: TextStyle(
                  fontSize: 14, //  Tamaño del valor
                  fontWeight: FontWeight.w500,
                  color:
                      valueColor ??
                      const Color(0xFF1A1A2E), //  Color del valor
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  WIDGET: _ActionTile — Fila de acción (navegable)
// Pueden cambiar íconos, colores y etiquetas.
// El onTap es donde conectan la navegación a otras pantallas.
// ============================================================
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, //  Conecten la navegación aquí
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF9CA3AF),
            ), //  Color del ícono
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14, //  Tamaño del texto
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E), //  Color del texto
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded, //  Cambien la flecha si quieren
              color: Color(0xFF9CA3AF), //  Color de la flecha
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
