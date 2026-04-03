import 'package:flutter/material.dart';
import '../models/phone_model.dart';
import '../viewmodels/contact_info_viewmodel.dart';

class AddEditPhoneDialog extends StatefulWidget {
  final ContactInfoViewModel vm;
  final PhoneModel? phone;

  const AddEditPhoneDialog({super.key, required this.vm, this.phone});

  @override
  State<AddEditPhoneDialog> createState() => _AddEditPhoneDialogState();
}

class _AddEditPhoneDialogState extends State<AddEditPhoneDialog> {
  final _phoneController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '');
  String _type = 'mobile';
  bool _isPrimary = false;

  @override
  void initState() {
    super.initState();
    if (widget.phone != null) {
      _phoneController.text = widget.phone!.phone;
      _countryCodeController.text = widget.phone!.countryCode;
      _type = widget.phone!.type.isNotEmpty ? widget.phone!.type : 'mobile';
      _isPrimary = widget.phone!.isPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.phone == null ? 'إضافة رقم' : 'تعديل الرقم'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'رقم الجوال أو التواصل',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _countryCodeController,
              decoration: const InputDecoration(
                labelText: 'مفتاح الدولة (مثال: +966)',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _type,
              items: const [
                DropdownMenuItem(value: 'mobile', child: Text('جوال')),
                DropdownMenuItem(value: 'whatsapp', child: Text('واتساب')),
                DropdownMenuItem(value: 'both', child: Text('جوال وواتساب')),
              ],
              onChanged: (val) => setState(() => _type = val ?? 'mobile'),
              decoration: const InputDecoration(labelText: 'نوع الرقم'),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('رقم أساسي'),
              value: _isPrimary,
              onChanged: (val) => setState(() => _isPrimary = val ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            final phoneText = _phoneController.text.trim();
            final country = _countryCodeController.text.trim();
            if (phoneText.isEmpty || country.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الرجاء إدخال رقم الجوال ومفتاح الدولة')),
              );
              return;
            }

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            bool success;
            if (widget.phone == null) {
              success = await widget.vm.addPhone(
                phone: phoneText,
                countryCode: country,
                type: _type,
                isPrimary: _isPrimary,
              );
            } else {
              success = await widget.vm.updatePhone(
                id: widget.phone!.id,
                phone: phoneText,
                countryCode: country,
                type: _type,
                isPrimary: _isPrimary,
              );
            }

            Navigator.pop(context); // Close loading
            if (success) {
              Navigator.pop(context); // Close dialog
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.vm.errorMessage ?? 'حدث خطأ')),
              );
            }
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
