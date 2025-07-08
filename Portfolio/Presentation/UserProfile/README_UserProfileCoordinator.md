# UserProfile Coordinator Pattern

## Descripción

El `UserProfileCoordinator` implementa el patrón Coordinator para centralizar la gestión de dependencias del módulo UserProfile. Este patrón mantiene la consistencia arquitectónica con el `LoginCoordinator` y mejora la gestión de dependencias.

## Estructura

```
UserProfile/
├── UserProfileCoordinator.swift          # Implementación principal del coordinator
├── UserProfileView.swift                 # View principal (modificada)
├── UserProfileViewModel.swift            # ViewModel (modificado)
├── UserProfileViewCoordinator.swift      # Navegación (modificado)
└── README_UserProfileCoordinator.md      # Este archivo
```

## Componentes

### 1. UserProfileCoordinatorProtocol
Define la interfaz que debe implementar el coordinator:
- `makeUserProfileView()` -> UserProfileView
- `makeUserProfileViewModel()` -> UserProfileViewModel
- `makeSettingsView(userProfile:)` -> SettingsView
- `makeChooseFromLibrarySettingsView(userInfo:)` -> ChooseFromLibrarySettingsView
- `makeTakePhotoSettingsView(userInfo:)` -> TakePhotoSettingsView
- `makeChangeUserNameView(userInfo:)` -> ChangeUserNameView
- `makeChangeDescriptionView(userInfo:)` -> ChangeDescriptionView

### 2. UserProfileCoordinator
Implementación principal que:
- Centraliza todas las dependencias del módulo UserProfile
- Crea y configura Use Cases con sus respectivos Repositories
- Proporciona métodos factory para crear Views y ViewModels

### 3. UserProfileCoordinatorFactory
Factory que facilita la creación del coordinator:
- `create()` - Para uso en producción
- `createForTesting()` - Para testing con dependencias mock

## Dependencias Gestionadas

El coordinator maneja las siguientes dependencias:

### Repositories
- `UserProfileRepositoryProtocol` - Gestión de perfil de usuario
- `CarAssetRepositoryProtocol` - Gestión de assets

### Use Cases
- `RetrieveUserProfileUseCaseProtocol` - Obtener perfil de usuario
- `FetchAssetsUseCaseProtocol` - Obtener assets
- `UpdateUserNicknameUseCaseProtocol` - Actualizar nickname
- `UpdateUserDescriptionUseCaseProtocol` - Actualizar descripción
- `UpdateUserCurrencyUseCaseProtocol` - Actualizar moneda
- `UpdateUserPrivacityUseCaseProtocol` - Actualizar privacidad
- `UploadUserProfileImageUseCaseProtocol` - Subir imagen de perfil

## Uso

### Uso Básico (Producción)
```swift
// En LoginView.swift
.fullScreenCover(isPresented: $viewModel.isLoggedIn) {
    UserProfileCoordinatorFactory.create().makeUserProfileView()
}
```

### Uso para Testing
```swift
// Crear coordinator con mocks
let coordinator = UserProfileCoordinatorFactory.createForTesting(
    userProfileRepository: MockUserProfileRepository(),
    carAssetRepository: MockCarAssetRepository()
)

let userProfileView = coordinator.makeUserProfileView()
```

### Uso Directo
```swift
// Crear coordinator con dependencias personalizadas
let coordinator = UserProfileCoordinator(
    userProfileRepository: UserProfileRepository(),
    carAssetRepository: CarAssetRepository()
)

let userProfileView = coordinator.makeUserProfileView()
```

## Beneficios

### 1. Consistencia Arquitectónica
- Mismo patrón que LoginCoordinator
- Arquitectura uniforme en toda la aplicación

### 2. Centralización de Dependencias
- Todas las dependencias del módulo UserProfile están en un solo lugar
- Facilita la gestión y mantenimiento

### 3. Inyección de Dependencias
- Permite inyectar mocks para testing
- No requiere modificar código de producción

### 4. Separación de Responsabilidades
- El coordinator se encarga solo de crear dependencias
- Views y ViewModels se enfocan en su lógica específica

### 5. Facilidad de Testing
- Permite crear diferentes configuraciones para testing
- Aísla las dependencias reales durante las pruebas

## Comparación Antes vs Después

### Antes
```swift
// Dependencias hardcodeadas en ViewModel
UserProfileView()

// En UserProfileViewModel
init(
    retrieveUserProfileUseCase: RetrieveUserProfileUseCaseProtocol = RetrieveUserProfileUseCase(repository: UserProfileRepository()),
    retrieveAssetsUseCase: FetchAssetsUseCaseProtocol = FetchAssetsUseCase(repository: CarAssetRepository())
) {
    // ...
}
```

### Después
```swift
// Uso del coordinator
UserProfileCoordinatorFactory.create().makeUserProfileView()

// Dependencias centralizadas en el coordinator
class UserProfileCoordinator {
    private lazy var retrieveUserProfileUseCase: RetrieveUserProfileUseCaseProtocol = {
        RetrieveUserProfileUseCase(repository: userProfileRepository)
    }()
    
    private lazy var retrieveAssetsUseCase: FetchAssetsUseCaseProtocol = {
        FetchAssetsUseCase(repository: carAssetRepository)
    }()
    
    // ...
}
```

## Integración con LoginCoordinator

El UserProfileCoordinator se integra perfectamente con el LoginCoordinator:

```swift
// En LoginView.swift
.fullScreenCover(isPresented: $viewModel.isLoggedIn) {
    UserProfileCoordinatorFactory.create().makeUserProfileView()
}
```

Esto mantiene la consistencia arquitectónica y permite que ambos módulos sigan el mismo patrón.

## Próximos Pasos

- Aplicar el mismo patrón a otros módulos (Assets, Settings, etc.)
- Crear un coordinator principal que gestione la navegación entre módulos
- Implementar un sistema de dependency injection más robusto si es necesario
- Crear tests unitarios usando los mocks del coordinator 