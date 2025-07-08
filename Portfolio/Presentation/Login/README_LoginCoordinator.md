# Login Coordinator Pattern

## Descripción

El `LoginCoordinator` implementa el patrón Coordinator para centralizar la gestión de dependencias del módulo de Login. Este patrón mejora la arquitectura de la aplicación proporcionando una mejor separación de responsabilidades y facilitando el testing.

## Estructura

```
LoginCoordinator/
├── LoginCoordinator.swift          # Implementación principal del coordinator
├── LoginCoordinatorExample.swift   # Ejemplos de uso
└── README_LoginCoordinator.md      # Este archivo
```

## Componentes

### 1. LoginCoordinatorProtocol
Define la interfaz que debe implementar el coordinator:
- `makeLoginRouterView()` -> LoginRouterView
- `makeLoginView(isLoggedIn:)` -> LoginView  
- `makeLoginViewModel(isLoggedIn:)` -> LoginViewModel
- `makeLoginRouterViewModel()` -> LoginRouterViewModel

### 2. LoginCoordinator
Implementación principal que:
- Centraliza todas las dependencias del módulo Login
- Crea y configura Use Cases con sus respectivos Repositories
- Proporciona métodos factory para crear Views y ViewModels

### 3. LoginCoordinatorFactory
Factory que facilita la creación del coordinator:
- `create()` - Para uso en producción
- `createForTesting()` - Para testing con dependencias mock

## Dependencias Gestionadas

El coordinator maneja las siguientes dependencias:

### Repositories
- `SessionRepositoryProtocol` - Gestión de sesiones
- `LoginRepositoryProtocol` - Operaciones de login
- `LoginWithPresentingProtocol` - Login con Google
- `CarAssetRepositoryProtocol` - Gestión de assets

### Use Cases
- `SaveSessionProtocol` - Guardar sesión
- `RetriveSessionUseCaseProtocol` - Recuperar sesión
- `LoginWithPresentationUseCaseProtocol` - Login con presentación
- `LoginWithTokenUseCaseProtocol` - Login con token
- `FetchAssetsUseCaseProtocol` - Obtener assets

## Uso

### Uso Básico (Producción)
```swift
// En ContentView.swift
struct ContentView: View {
    var body: some View {
        LoginCoordinatorFactory.create().makeLoginRouterView()
    }
}
```

### Uso para Testing
```swift
// Crear coordinator con mocks
let coordinator = LoginCoordinatorFactory.createForTesting(
    sessionRepository: MockSessionRepository(),
    loginRepository: MockLoginRepository(),
    googleSignInRepository: MockGoogleSignInRepository(),
    carAssetRepository: MockCarAssetRepository()
)

let loginView = coordinator.makeLoginRouterView()
```

### Uso Directo
```swift
// Crear coordinator con dependencias personalizadas
let coordinator = LoginCoordinator(
    sessionRepository: SessionRepository.shared,
    loginRepository: LoginRepository(),
    googleSignInRepository: GoogleSignInRepository(),
    carAssetRepository: CarAssetRepository()
)

let loginView = coordinator.makeLoginRouterView()
```

## Beneficios

### 1. Centralización de Dependencias
- Todas las dependencias del módulo Login están en un solo lugar
- Facilita la gestión y mantenimiento

### 2. Inyección de Dependencias
- Permite inyectar mocks para testing
- No requiere modificar código de producción

### 3. Separación de Responsabilidades
- El coordinator se encarga solo de crear dependencias
- Views y ViewModels se enfocan en su lógica específica

### 4. Facilidad de Testing
- Permite crear diferentes configuraciones para testing
- Aísla las dependencias reales durante las pruebas

### 5. Escalabilidad
- Facilita agregar nuevas dependencias
- Modificar dependencias existentes sin afectar múltiples archivos

## Comparación Antes vs Después

### Antes
```swift
// Dependencias hardcodeadas en ViewModel
LoginView(viewModel: .init(isLoggedIn: viewModel.isSavedUser))

// En LoginViewModel
init(isLoggedIn: Bool = false,
     saveSessionUseCase: SaveSessionProtocol = SaveSessionUseCase(SessionRepository.shared),
     googleLogin: LoginWithPresentationUseCaseProtocol = LoginWithPresentationUseCase(repository: GoogleSignInRepository()),
     loginWithToken: LoginWithTokenUseCaseProtocol = LoginWithTokenUseCase(repository: LoginRepository())) {
    // ...
}
```

### Después
```swift
// Uso del coordinator
LoginCoordinatorFactory.create().makeLoginRouterView()

// Dependencias centralizadas en el coordinator
class LoginCoordinator {
    private lazy var saveSessionUseCase: SaveSessionProtocol = {
        SaveSessionUseCase(sessionRepository)
    }()
    
    private lazy var googleLoginUseCase: LoginWithPresentationUseCaseProtocol = {
        LoginWithPresentationUseCase(repository: googleSignInRepository)
    }()
    
    // ...
}
```

## Migración

Para migrar otros módulos a este patrón:

1. **Crear el Coordinator**: Centralizar todas las dependencias del módulo
2. **Definir el Protocol**: Crear la interfaz del coordinator
3. **Crear el Factory**: Proporcionar métodos de creación
4. **Actualizar las Views**: Usar el coordinator en lugar de crear dependencias directamente
5. **Actualizar Tests**: Usar el factory de testing con mocks

## Próximos Pasos

- Aplicar el mismo patrón a otros módulos (Assets, User, etc.)
- Crear un coordinator principal que gestione la navegación entre módulos
- Implementar un sistema de dependency injection más robusto si es necesario 