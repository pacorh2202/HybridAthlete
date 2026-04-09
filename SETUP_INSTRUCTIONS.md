# 🚀 Instrucciones de Setup para HybridAthlete

## Lo que hemos creado para ti

He generado **la estructura completa de Fase 1 (MVP)** en el repositorio GitHub. Incluye:

✅ **Estructura MVVM profesional**
✅ **Modelos** (User, BodyMeasurement, AuthError)
✅ **Servicios** (SupabaseService con métodos Auth)
✅ **ViewModels** (AuthenticationViewModel)
✅ **Vistas** (AuthView, DashboardView, SettingsView)
✅ **Colores y Extensions** listos para usar

## Pasos para empezar

### 1. Clona el repositorio

```bash
git clone https://github.com/pacorh2202/HybridAthlete.git
cd HybridAthlete
```

### 2. Abre en Xcode

```bash
open .
```

O arrastra la carpeta a Xcode.

### 3. Crea un proyecto en Supabase

- Ve a https://supabase.com
- Crea cuenta gratis
- Nuevo proyecto (espera 5-10 min a que se inicialice)
- Ve a **Project Settings** → **API**
- Copia: **Project URL** y **Anon Key**

### 4. Configura Supabase en el código

Abre `HybridAthlete/Data/Services/SupabaseService.swift` y reemplaza:

```swift
private let supabaseURL = "YOUR_SUPABASE_URL"      // ← Reemplaza aquí
private let supabaseAnonKey = "YOUR_SUPABASE_ANON_KEY"  // ← Y aquí
```

### 5. Crea las tablas en Supabase

En Supabase, ve a **SQL Editor** y ejecuta este script completo:

```sql
-- Tabla de usuarios
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  birth_date DATE,
  sex TEXT,
  height_cm FLOAT,
  weight_kg FLOAT,
  goal TEXT,
  experience_level TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de mediciones corporales
CREATE TABLE public.body_measurements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date DATE NOT NULL DEFAULT NOW(),
  weight_kg FLOAT NOT NULL,
  waist_cm FLOAT,
  hip_cm FLOAT,
  chest_cm FLOAT,
  arm_cm FLOAT,
  thigh_cm FLOAT,
  neck_cm FLOAT,
  body_fat_pct FLOAT,
  lean_mass_kg FLOAT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Row Level Security
ALTER TABLE public.body_measurements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_view_own_measurements"
ON public.body_measurements
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "users_insert_own_measurements"
ON public.body_measurements
FOR INSERT
WITH CHECK (auth.uid() = user_id);
```

### 6. Compila y ejecuta en Xcode

- **Cmd + R** para ejecutar en simulador
- Verás la pantalla de login
- Puedes registrarte o iniciar sesión

## Estructura del código

```
HybridAthlete/
├── App/                    ← Punto de entrada (HybridAthleteApp.swift)
├── Core/
│   ├── Models/             ← User, BodyMeasurement, AuthError
│   └── Extensions/         ← Colores y extensiones
├── Data/
│   └── Services/           ← SupabaseService (toda la lógica de API)
└── Features/
    ├── Auth/               ← Login/Registro
    └── Dashboard/          ← Pantalla principal
```

## El código está listo para...

### ✅ Login/Registro funcional
- Crea usuarios en Supabase Auth
- Valida email y contraseña
- Almacena tokens de sesión

### ✅ Dashboard básico
- Muestra los datos del usuario
- Cards de progreso (próximamente se rellenarán)
- Botón para cerrar sesión

### ✅ Extensible
- Estructura MVVM lista para agregar más features
- Cada módulo está separado
- Fácil de mantener y escalar

## Próximos pasos (semana que viene)

1. **Onboarding completo**: Agregar fotos, medidas, objetivo
2. **Body Analysis**: Integrar GPT-4o Vision para analizar fotos
3. **Nutrición**: Planes de dieta personalizados
4. **Entrenamientos**: Rutinas de gym con tracking

## Si algo no funciona

Comprueba:

1. ✅ ¿Copiaste bien la URL y Anon Key de Supabase?
2. ✅ ¿Creaste las tablas con el SQL script?
3. ✅ ¿Xcode ve el código Swift sin errores?

Si ves errores, dame los detalles y lo arreglamos juntos.

## Próxima sesión

Una vez que todo compile y puedas registrarte/iniciar sesión, te digo cómo agregar:
- Onboarding con fotos
- Integración con GPT-4o
- Planes personalizados

¡Vamos a crear algo increíble! 🚀
