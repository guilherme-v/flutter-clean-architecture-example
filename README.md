# Flutter Clean Architecture Proposal

# Goals
- Keep code clean
- Keep code testable
- Keep codebase easily extensible and adaptable
- Test different State Managaments libraries (currently: BLOC, Provider, States Rebuilder and State Notifier)
  

# Architecture Overview

![architecture](./art/arch1.png?raw=true)

As described in Uncle Bob's webpage, clean architecture enforces the separations of concerns dividing the software into layers. Each one of these layers focuses on doing one single thing, so it follows the Single Responsibility Principle. They also have their own Model representations and any communication needed with external layers are made through the use of abstractions. 

The architecture also follows the Dependency Rule, which states that an outer layer can depend on an inner layer, but the other way around is not possible. As result, the application becomes highly decoupled, easy to maintain, to test and to adapt.

### Known limitations
- The initial set up involves dealing with some boilerplate code

### Known benefits
- A/B testing can be applied easily, and it will touch only one layer (the Presentation Layer).
- Feature toggle can be used easily, both to enable/disable features or to try out new ideas (without needing to release a new version).
- All layers can be unit tested independently.
- Unidirectional data flow makes it easy to understand the code.
- We can use different State Managements libraries (Provider, BLOC, States Rebuilder, State Notifier...) on the Presentation layer, or even try out new ones easily if needed
  
# Details

![architecture](./art/arch2.png?raw=true)


### MobileUI

### Presentation
The application user interface. It depends on the Flutter Framework containing classes responsible for:
- Build the UI: like ``Widgets``, ``BuildContexts``, and others.
- Hold the Presentation logic: ``ChangeNotifier``, ``BLOC``, ``ViewModels``, and others.

The presentation logic will receive data from the Domain's use cases, and then it will prepare these data to be presented on the UI. In general, it is the recommended place to format/internationalize things. For example, it can receive from the Domain a ``DateTime`` object with the format ``"1969-07-20 20:18:04Z"`` and prepare/format this data to be presented on the UI according to the user's device language.

### Domain
It represents the domain of the problem we are trying to solve, that is, your business rules. It is the architecture's central layer, therefore, it has no dependencies on external layers and should be a plain dart module. It includes:
- plain entity classes (like ``Character`` entity)
- usecase classes, that encapsulate all the business logic related to a particular usecase (like ``GetAllCharacters``, ``SignInUser``, and others...)
- data access abstractions (Repository Interfaces)
  
A use-case has no clue if the data it'll receive comes from a memory cache, local storage, or the internet. All these details were abstract out by the use of the Repositories' Interfaces, and from the use-case point of view, all that matters is that it'll receive its data. 

### Data
It is the layer that implements the data access abstractions (Repository Interfaces) defined into the domain. In other words, it is the layer responsible for providing data to those use cases. It is "the brain" that knows how/when to fetch data from the network or local cache, and how/when to cache things. It includes:
- It is the Implementations of repositories defined by domain layer
- It'll hold/manage any in memory caches
- It'll define Data-source abstractions (like ``RemoteDatasourceInterface``, ``LocalCacheDatasourceInterface``)
  
It works like a "boundary" between our application and the external world in a certain way. It will "translate" how things are "fetched" from/to the internet, or "loaded" from/to the database, to how these same things are represented in our Domain.


### Network
Layer responsible for handle the communication to the network. It has the implementation of the remote abstraction (``RemoteDatasourceInterface``) defined into the Data layer:
- We define the endpoints we are going to use
- We configure any interceptors we need
- We serialize/deserialize the JSON to Data objects

It represents a "boundary" with the external world. We are translating the "language" our API uses to communicate (JSON) to something that we can understand and work better (Data object).

### Local
This layer provides access to any kind of local storage: database, shared preferences, files, and others. It implements the abstractions (``LocalCacheDatasourceInterface``) defined into the Data layer.

It represents a "boundary" with the inner world. I mean, how we store things in our local device. We can use shared-preferences' key-values, serialize/deserialize things into files, read/write from the database, etc. 

The point is: Each method has its way to "save" and "read" things, and this layer will translate this way to objects that our Data Layer knows how to handle.


# Generic Error Handling and Data Layer
The Data layer will encapsulate all kinds of try-catches, from this layer upwards there will be no special flow to handle errors. Repositories will return Either a Failure (in case of any error) or a Value in case of success (``Either<Failure, Value>``).

We will also use two generic classes to represent any kind of error that may occur on the Network layer and LocalCache layer - ``ServerFailure``, and ``CacheFailure`` respectively.

If any of these errors occur, Data Layer will also log the event properly. Example:
1. A use-case asks for all characters available
2. The repository verify that the Device is online, and it goes on and tries to fetch data from Network
3. Network layer tries to fetch data from remote API, but an unexpected problem occurs and we've got back an Error 500
4. The repository catches the error
5. The repository logs it on Analytics
6. The repository answers back to use case an ``Either<ServerFailure, null>`` object
   

# References
- [Joe Birch - Google GDE: Clean Architecture Course](https://caster.io/courses/android-clean-architecture)
- [Reso Coder - Flutter TDD Clean Architecture](https://www.youtube.com/playlist?list=PLB6lc7nQ1n4iYGE_khpXRdJkJEp9WOech)
- [Majid Hajian | Flutter Europe - Strategic Domain Driven Design to Flutter](https://youtu.be/lGv6KV5u75k)
- [Guide to app architecture - Jetpack Guides](https://developer.android.com/jetpack/docs/guide#common-principles)
- [ABHISHEK TYAGI - TopTal Developer: Better Android Apps Using MVVM with Clean Architecture](https://www.toptal.com/android/android-apps-mvvm-with-clean-architecture)
- [Jason Taylor (+20 years of experience) - Clean Architecture ](https://youtu.be/Zygw4UAxCdg)
- [Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)