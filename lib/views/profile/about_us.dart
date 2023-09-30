import 'package:bird_x/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/app_text.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const AppText(
          text: "About us",
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AppSpacing.heigthSpace10,
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                  children: [
                    const TextSpan(
                      text: "Welcome to ",
                    ),
                    TextSpan(
                      text: "PetX",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ", your ultimate platform for all your pet, bird, and fish needs! We've completely reimagined the way you connect with your beloved animal companions, whether they have fur, feathers, or scales. Our app is the go-to destination for enthusiasts of all kinds, simplifying the process of buying, selling, and connecting with fellow pet lovers.",
                    ),
                    const TextSpan(
                      text: "\n\nAt ",
                    ),
                    TextSpan(
                      text: "PetX",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ", we understand the unique bonds people share with their pets, birds, and fish. Whether you're looking for your next loyal companion, seeking to rehome a beloved pet, or in search of specialized services and products, our app provides a seamless, secure, and pet-centric experience. We're dedicated to ensuring the well-being of all animals, from playful puppies and chatty parrots to exotic fish species.",
                    ),
                    const TextSpan(
                      text: "\n\nBut ",
                    ),
                    TextSpan(
                      text: "PetX",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text:
                          " is more than just a marketplace; it's a thriving community. We're here to connect animal enthusiasts, share heartwarming stories, and offer support. Our commitment to responsible pet ownership, bird care, and fishkeeping practices sets us apart, making us the ultimate destination for all your animal needs.",
                    ),
                    const TextSpan(
                      text: "\n\nJoin us today and become part of a vibrant, caring community. ",
                    ),
                    TextSpan(
                      text: "PetX",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text: " - where pets, birds, and fish find loving homes, and animal lovers unite. Discover, connect, and share your love for your beloved companions with us!",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
