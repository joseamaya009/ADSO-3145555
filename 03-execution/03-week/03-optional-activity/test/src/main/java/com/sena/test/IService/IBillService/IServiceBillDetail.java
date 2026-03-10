package com.sena.test.IService.IBillService;

import java.util.List;

import com.sena.test.DTO.BillDTO.BillDetailDTORequest;
import com.sena.test.DTO.BillDTO.BillDetailDTOResponse;

public interface IServiceBillDetail {

      BillDetailDTOResponse createDetail(Long billId, BillDetailDTORequest request);

    List<BillDetailDTOResponse> getDetailsByBill(Long billId);

    void deleteDetail(Long id);

}
