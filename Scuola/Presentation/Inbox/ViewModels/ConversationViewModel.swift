//
//  ConversationViewModel.swift
//  Scuola
//
//  Created by Braden Ross on 3/27/24.
//

/*
 FIXME: When retrieving the message from AWS Amplify, an error logs
 
 Raw subscription event: data(Swift.Result<Scuola.Conversation, Amplify.GraphQLResponseError<Scuola.Conversation>>.failure(GraphQLResponseError<Conversation>: Failed to decode GraphQL response to the `ResponseType` Conversation
 Recovery suggestion: Failed to transform to `ResponseType`.
 Take a look at the `RawGraphQLResponse` and underlying error to see where it failed to decode.
 Caused by:
 APIError: keyNotFound key CodingKeys(stringValue: "id", intValue: nil)
 Caused by:
 keyNotFound(CodingKeys(stringValue: "id", intValue: nil), Swift.DecodingError.Context(codingPath: [], debugDescription: "No value associated with key CodingKeys(stringValue: \"id\", intValue: nil) (\"id\").", underlyingError: nil))))
 Subscription error: The operation couldn’t be completed. (Amplify.GraphQLResponseError<Scuola.Conversation> error 2.)
 Other GraphQLResponseError: GraphQLResponseError<Conversation>: Failed to decode GraphQL response to the `ResponseType` Conversation
 */

import Foundation
import Amplify

class ConversationViewModel: ObservableObject {
    @Published var user: User = User(name: "Braden Ross", bio: "", birthdate: Temporal.DateTime.now(), picture: "", userType: "default", username: "braden", verified: false)
    @Published var loading = false
    @Published var messageCount = 0
    
    var conversationID: String
    var subscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<Conversation>>?
    var conversationSubscription: AmplifyAsyncThrowingSequence<DataStoreQuerySnapshot<Conversation>>?
    
    init(conversationID: String){
        self.conversationID = conversationID
    }
    
    deinit{
        self.unsubscribeToConversation()
    }
    
    private func getUser(byId userId: String) async {
        do {
            let result = try await Amplify.API.query(
                request: .get(User.self, byId: userId)
            )
            switch result {
            case .success(let model):
                guard let model = model else {
                    print("Could not find model")
                    return
                }
                DispatchQueue.main.async {
                    self.user = model
                    print("Successfully retrieved and updated model: \(model)")
                }
            case .failure(let error):
                print("Got failed result with \(error)")
            }
        } catch let error as APIError {
            print("Failed to query user - \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func subscribeToConversation() {
        let request = GraphQLRequest<Conversation>.updatedConversation()
        subscription = Amplify.API.subscribe(request: request)
        Task {
            do {
                for try await event in subscription! {
                    print("Raw subscription event: \(event)")
                    switch event {
                    case .connection(let state):
                        print("Connection state is \(state)")
                    case .data(let result):
                        switch result {
                        case .success(let conversation):
                            DispatchQueue.main.async {
                                print("Received update: \(conversation)")
                            }
                        case .failure(let error):
                            print("Subscription error: \(error.localizedDescription)")
                            if let responseError = error as? GraphQLResponseError<Conversation> {
                                switch responseError {
                                case .error(let errors):
                                    errors.forEach { print("GraphQL Error: \($0.message)") }
                                default:
                                    print("Other GraphQLResponseError: \(responseError)")
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Subscription ended with error: \(error)")
            }
        }
    }

    

    
    func unsubscribeToConversation() {
        conversationSubscription?.cancel()
    }
    
    func createMessage(content: String) async {
        do {
            let currentUser = try await Amplify.Auth.getCurrentUser()
            let currentUserId = currentUser.userId

            let newMessage = Message(content: content, createdAt: Temporal.DateTime.now(), sender: currentUserId, conversationID: conversationID)
            
            let result = try await Amplify.API.mutate(request: .create(newMessage))
            switch result {
            case .success(let message):
                print("Successfully created message: \(message)")
                
                await updateConversationLastMessageId(messageId: message.id)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch {
            print("Failed to create message or update conversation: \(error)")
        }
    }
    
    private func updateConversationLastMessageId(messageId: String) async {
        do {
            // Assuming you have already fetched the conversation details elsewhere and have it stored
            let fetchResult = try await Amplify.API.query(request: .get(Conversation.self, byId: conversationID))
            switch fetchResult {
            case .success(let fetchedConversation):
                guard var conversation = fetchedConversation else {
                    print("Conversation not found")
                    return
                }
                conversation.lastMessageID = messageId
                let updateResult = try await Amplify.API.mutate(request: .update(conversation))
                switch updateResult {
                case .success(let updatedConversation):
                    print("Conversation updated successfully: \(updatedConversation)")
                case .failure(let error):
                    print("Failed to update Conversation: \(error)")
                }
            case .failure(let error):
                print("Error fetching conversation: \(error)")
            }
        } catch {
            print("Error performing mutation: \(error)")
        }
    }
}

extension GraphQLRequest {
    static func updatedConversation() -> GraphQLRequest<Conversation> {
        let document = """
        subscription OnUpdateConversation(
          $filter: ModelSubscriptionConversationFilterInput
        ) {
          onUpdateConversation(filter: $filter) {
            id
            messages {
              nextToken
              __typename
            }
            participants
            lastMessageID
            createdAt
            updatedAt
            __typename
          }
        }
        """
        return GraphQLRequest<Conversation>(document: document, responseType: Conversation.self)
    }
}
