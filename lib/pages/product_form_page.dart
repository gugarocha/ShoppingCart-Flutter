import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.jpg');

    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    _formKey.currentState?.save();

    setState(() => isLoading = true);

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);

      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text(
            'Ocorreu um erro ao salvar o produto. Tente novamente.',
          ),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      initialValue: _formData['name']?.toString(),
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      validator: (value) {
                        final name = value ?? '';

                        if (name.trim().isEmpty) {
                          return 'Nome é obrigatório.';
                        }
                        if (name.length < 3) {
                          return 'Nome deve conter no mínimo 3 letras.';
                        }

                        return null;
                      },
                      onSaved: (name) => _formData['name'] = name ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Preço'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      initialValue: _formData['price']?.toString(),
                      focusNode: _priceFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      validator: (value) {
                        final stringPrice = value ?? '';
                        final price = double.tryParse(stringPrice) ?? -1;

                        if (price <= 0) {
                          return 'Informe um preço válido.';
                        }

                        return null;
                      },
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? '0'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      initialValue: _formData['description']?.toString(),
                      textCapitalization: TextCapitalization.sentences,
                      focusNode: _descriptionFocus,
                      validator: (value) {
                        final description = value ?? '';

                        if (description.trim().isEmpty) {
                          return 'Descrição é obrigatório.';
                        }
                        if (description.length < 5) {
                          return 'Descrição deve conter no mínimo 5 letras.';
                        }

                        return null;
                      },
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'URL da imagem',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submitForm(),
                            focusNode: _imageUrlFocus,
                            controller: _imageUrlController,
                            onSaved: (imageUrl) =>
                                _formData['imageUrl'] = imageUrl ?? '',
                            validator: (value) {
                              final imageUrl = value ?? '';

                              if (!isValidImageUrl(imageUrl)) {
                                return 'Informe uma URL válida.';
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 20,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Informe a URL')
                                : Image.network(_imageUrlController.text),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
