const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const pool = require('../config/db');

function createToken(user) {
  return jwt.sign(
    {
      id_usuario: user.id_usuario,
      email: user.email,
      rol: user.rol,
    },
    process.env.JWT_SECRET,
    { expiresIn: '7d' }
  );
}

async function register(req, res) {
  try {
    const { nombre, email, password, ubicacion, idioma_pref } = req.body;

    if (!nombre || !email || !password) {
      return res.status(400).json({
        message: 'Nombre, email y contraseña son obligatorios.',
      });
    }

    const [existingUsers] = await pool.query(
      'SELECT id_usuario FROM usuarios WHERE email = ?',
      [email]
    );

    if (existingUsers.length > 0) {
      return res.status(409).json({
        message: 'Ese correo ya está registrado.',
      });
    }

    const password_hash = await bcrypt.hash(password, 10);

    const [result] = await pool.query(
      `INSERT INTO usuarios (nombre, email, password_hash, rol, idioma_pref, ubicacion)
       VALUES (?, ?, ?, 'usuario', ?, ?)`,
      [
        nombre,
        email,
        password_hash,
        idioma_pref || 'es',
        ubicacion || null,
      ]
    );

    const [rows] = await pool.query(
      `SELECT id_usuario, nombre, email, rol, idioma_pref, ubicacion, creado_en
       FROM usuarios
       WHERE id_usuario = ?`,
      [result.insertId]
    );

    const user = rows[0];
    const token = createToken(user);

    return res.status(201).json({
      message: 'Usuario registrado correctamente.',
      token,
      user,
    });
  } catch (error) {
    console.error('Error en register:', error);
    return res.status(500).json({
      message: 'Error interno del servidor al registrar usuario.',
    });
  }
}

async function login(req, res) {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        message: 'Email y contraseña son obligatorios.',
      });
    }

    const [rows] = await pool.query(
      `SELECT id_usuario, nombre, email, password_hash, rol, idioma_pref, ubicacion, creado_en
       FROM usuarios
       WHERE email = ?`,
      [email]
    );

    if (rows.length === 0) {
      return res.status(401).json({
        message: 'Credenciales inválidas.',
      });
    }

    const user = rows[0];
    const validPassword = await bcrypt.compare(password, user.password_hash);

    if (!validPassword) {
      return res.status(401).json({
        message: 'Credenciales inválidas.',
      });
    }

    const token = createToken(user);

    return res.status(200).json({
      message: 'Inicio de sesión correcto.',
      token,
      user: {
        id_usuario: user.id_usuario,
        nombre: user.nombre,
        email: user.email,
        rol: user.rol,
        idioma_pref: user.idioma_pref,
        ubicacion: user.ubicacion,
        creado_en: user.creado_en,
      },
    });
  } catch (error) {
    console.error('Error en login:', error);
    return res.status(500).json({
      message: 'Error interno del servidor al iniciar sesión.',
    });
  }
}

module.exports = {
  register,
  login,
};